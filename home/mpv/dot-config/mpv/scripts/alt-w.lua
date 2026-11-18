-- Alt-W: watch-later browser. Ctrl-P and the built-in menu are unchanged.
local mp = require 'mp'
local utils = require 'mp.utils'
local assdraw = require 'mp.assdraw'
local entries, shown, selected, query = {}, {}, 1, ''
local active, busy, job = false, false, nil
local failed, bindings = {}, {}
local images = {}
local overlay = mp.create_osd_overlay('ass-events')
local cache = utils.join_path(os.getenv('XDG_CACHE_HOME') or mp.command_native({'expand-path', '~/.cache'}), 'mpv/watch-later-thumbnails')
local tw, th = 240, 136
local rows, first, layout = 1, 1, nil
local last_move = -math.huge
local duration_job, duration_timer
local duration_failed = {}
local render, pump, pump_duration
local function escape(s)
    return s:gsub('\\', '\\e'):gsub('{', '\\{'):gsub('}', '\\}'):gsub('[\r\n]', ' ')
end
local function youtube_id(path)
    path = path:gsub('^ytdl://', '')
    local host, rest = path:match('^https?://([^/]+)/(.+)$')
    if not host then return nil end
    host = host:lower()
    local id
    if host == 'youtu.be' then
        id = rest:match('^([^?&#/]+)')
    elseif host == 'youtube.com' or host:match('%.youtube%.com$') or host == 'youtube-nocookie.com' or host:match('%.youtube%-nocookie%.com$') then
        id = rest:match('[?&]v=([^&#]+)') or rest:match('^shorts/([^?&#/]+)')
            or rest:match('^embed/([^?&#/]+)') or rest:match('^live/([^?&#/]+)')
    end
    if id and #id == 11 and id:match('^[%w_-]+$') then return id end
end
local function remove_images()
    for id in pairs(images) do mp.commandv('overlay-remove', id) end
    images = {}
end
local function close()
    active = false
    overlay:remove()
    remove_images()
    for _, name in ipairs(bindings) do mp.remove_key_binding(name) end
    bindings = {}
end
local function filter()
    shown = {}
    for _, e in ipairs(entries) do
        if e.title:lower():find(query:lower(), 1, true) then shown[#shown + 1] = e end
    end
    selected, first = 1, 1
end
local function text(a, x, y, size, color, value)
    a:new_event()
    a:append(string.format('{\\an7\\pos(%d,%d)\\fs%d\\bord0\\shad0\\c&H%s&}', x, y, size, color))
    a:append(escape(value))
end
local function rect(a, x, y, w, h, color, alpha)
    a:new_event()
    a:append(string.format('{\\an7\\pos(0,0)\\bord0\\shad0\\c&H%s&\\alpha&H%s&}', color, alpha or '00'))
    a:draw_start(); a:rect_cw(x, y, x + w, y + h); a:draw_stop()
end
local function format_time(value)
    if not value then return '—' end
    local seconds = math.floor(value)
    return string.format('%d:%02d:%02d', math.floor(seconds/3600), math.floor(seconds/60)%60, seconds%60)
end
render = function()
    if not active then return end
    local w, h = mp.get_osd_size()
    if w <= 0 or h <= 0 then return end
    -- Text follows window height, not width: tiling should wrap text, not shrink it.
    local scale = math.max(1, math.min(h / 720, 1.6))
    local margin, header = math.floor(24 * scale), math.floor(100 * scale)
    local row_h = math.floor(113 * scale)
    local iw = math.floor(math.min(200 * scale, w * 0.28))
    local ih = math.floor(iw * 113 / 200)
    local gap = math.max(8, math.floor(12 * scale))
    local rh = row_h + gap
    local scroll_w = math.max(2, math.floor(2.75 * scale))
    local scroll_x = w - margin - scroll_w
    local content_right = scroll_x - gap
    rows = math.max(1, math.min(12, math.floor((h - header - 50 * scale) / rh)))
    -- Keep the viewport still until selection crosses an edge (no scrolloff).
    if selected < first then first = selected end
    if selected >= first + rows then first = selected - rows + 1 end
    first = math.max(1, math.min(first, math.max(1, #shown - rows + 1)))
    layout = {x = margin, y = header, rh = rh, iw = iw, ih = ih, right = content_right, scroll_x = scroll_x, scroll_w = scroll_w, scroll_h = rows * rh - gap}
    local a = assdraw.ass_new()
    rect(a, 0, 0, w, h, '161616', '12')
    text(a, margin, margin, math.floor(26 * scale), 'FFFFFF', 'Watch later  —  ' .. #shown .. ' entries')
    text(a, margin, math.floor(62 * scale), math.floor(18 * scale), 'CCCCCC', 'Search: ' .. query .. '▏')
    local visible_images = {}
    for slot = 1, rows do
        local idx = first + slot - 1
        local e = shown[idx]
        if not e then break end
        local y = header + (slot - 1) * rh
        if idx == selected then rect(a, margin - gap/2, y - gap/2, content_right - margin + gap/2, rh, '504030') end
        local image_y = y + math.floor((row_h - ih) / 2)
        rect(a, margin, image_y, iw, ih, '292929')
        local info = utils.file_info(e.thumb)
        if info and info.size == tw * th * 4 then
            local signature = table.concat({e.thumb, margin, image_y, iw, ih}, '|')
            visible_images[slot] = signature
            -- Replace changed bitmaps in place; never clear the whole menu first.
            if images[slot] ~= signature then
                mp.commandv('overlay-add', slot, margin, image_y, e.thumb, 0, 'bgra', tw, th, tw * 4, iw, ih)
            end
        else
            text(a, margin + gap, image_y + ih/3, math.floor(15*scale), 'AAAAAA', (e.local_file or e.youtube_id) and (failed[e.thumb] and 'No preview' or 'Loading…') or 'Stream / missing file')
        end
        local tx = margin + iw + gap
        local font = math.max(12, math.floor(20 * scale))
        local limit = math.max(8, math.floor((content_right - tx) / (font * 0.58)))
        -- Wrap on UTF-8 character boundaries, never in the middle of a glyph.
        local chars = {}
        for c in e.title:gmatch('[%z\1-\127\194-\244][\128-\191]*') do chars[#chars+1] = c end
        for line = 1, 2 do
            local part = table.concat(chars, '', (line-1)*limit+1, math.min(line*limit, #chars))
            if line == 2 and #chars > 2*limit then part = part .. '…' end
            text(a, tx, y + (line-1)*(font+3), font, 'FFFFFF', part)
            if #chars <= line*limit then break end
        end
        local source_path = e.path
        local home_dir = os.getenv('HOME')
        if home_dir and source_path:sub(1, #home_dir + 1) == home_dir .. '/' then
            source_path = '~' .. source_path:sub(#home_dir + 1)
        end
        local source_kind = e.youtube_id and 'YouTube' or
            (e.path:find('://', 1, true) and 'Stream' or 'Local file')
        local source_text = source_kind .. ' · ' .. source_path
        local source_font = math.max(10, math.floor(14 * scale))
        local source_limit = math.max(12, math.floor((content_right - tx) / (source_font * 0.58)))
        local source_chars = {}
        for c in source_text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do source_chars[#source_chars+1] = c end
        if #source_chars > source_limit then
            -- Keep the source label and filename visible for long paths.
            local head = math.floor(source_limit / 3)
            source_text = table.concat(source_chars, '', 1, head) .. '…' ..
                table.concat(source_chars, '', #source_chars - (source_limit - head - 1) + 1)
        end
        text(a, tx, y + row_h - math.floor(55*scale), source_font, 'AAAAAA', source_text)
        local duration_file = io.open(e.thumb .. '.duration')
        if duration_file then e.duration = tonumber(duration_file:read('*a')); duration_file:close() end
        local bar_y, bar_h = y + row_h - math.floor(7*scale), math.max(3, math.floor(4*scale))
        local bar_w = content_right - tx
        rect(a, tx, bar_y, bar_w, bar_h, '444444')
        if e.duration and e.duration > 0 then
            local progress = math.max(0, math.min(1, e.position / e.duration))
            rect(a, tx, bar_y, bar_w * progress, bar_h, 'D9AE77')
            text(a, content_right - math.floor(55*scale), y + row_h - math.floor(31*scale), math.floor(16*scale), 'BBBBBB', string.format('%d%%', math.floor(progress*100)))
        else
            text(a, content_right - math.floor(55*scale), y + row_h - math.floor(31*scale), math.floor(16*scale), 'BBBBBB', '—%')
        end
        local status_font = math.floor(16*scale)
        local status = string.format('Resume %s / %s', format_time(e.position), format_time(e.duration))
        local dated_status = os.date('%Y-%m-%d', e.mtime) .. '   •   ' .. status
        local status_w = content_right - tx - math.floor(65*scale)
        if #dated_status * status_font * 0.55 <= status_w then status = dated_status end
        -- Narrow tiles keep the times; the less important date drops out first.
        if #status * status_font * 0.55 > status_w then
            status = format_time(e.position) .. ' / ' .. format_time(e.duration)
        end
        text(a, tx, y + row_h - math.floor(31*scale), status_font, 'BBBBBB', status)
    end
    for id in pairs(images) do
        if not visible_images[id] then mp.commandv('overlay-remove', id) end
    end
    images = visible_images
    -- A proportional thumb shows the visible range within the filtered list.
    local track_h = layout.scroll_h
    rect(a, scroll_x, header, scroll_w, track_h, '303030')
    if #shown > 0 then
        local thumb_h = math.min(track_h, math.max(math.floor(36*scale), track_h * math.min(rows, #shown) / #shown))
        local fraction = #shown > rows and (first - 1) / (#shown - rows) or 0
        rect(a, scroll_x, header + (track_h - thumb_h) * fraction, scroll_w, thumb_h, 'D9AE77')
    end
    if #shown == 0 then text(a, margin, header, 22, 'CCCCCC', 'No matching watch-later entries') end
    text(a, margin, h - math.floor(32*scale), math.floor(16*scale), 'BBBBBB', '↑/↓ Ctrl-P/N Select   Enter Resume   Esc Close   Type to search   Alt-W Toggle')
    overlay.res_x, overlay.res_y, overlay.data = w, h, a.text
    overlay:update()
    pump()
    pump_duration()
end
pump = function()
    if busy or not active then return end
    for i = first, math.min(#shown, first + rows - 1) do
        local e = shown[i]
        local info = utils.file_info(e.thumb)
        if (e.local_file or e.youtube_id) and not failed[e.thumb] and not (info and info.size == tw*th*4) then
            busy = true
            local temp = e.thumb .. '.' .. utils.getpid() .. '.tmp'
            local image = temp .. '.jpg'
            local function finish(success, result)
                busy, job = false, nil
                local f = utils.file_info(temp)
                if success and result and result.status == 0 and f and f.size == tw*th*4 then
                    os.rename(temp, e.thumb)
                else
                    failed[e.thumb] = true
                    os.remove(temp)
                end
                os.remove(image)
                render()
            end
            local function convert(source, position)
                local args = {'ffmpeg', '-nostdin', '-v', 'error', '-y'}
                if position then args[#args+1] = '-ss'; args[#args+1] = tostring(position) end
                for _, v in ipairs({'-i', source, '-frames:v', '1', '-an', '-sn', '-vf', 'scale=240:136:force_original_aspect_ratio=decrease,pad=240:136:(ow-iw)/2:(oh-ih)/2,setsar=1', '-threads', '1', '-pix_fmt', 'bgra', '-f', 'rawvideo', temp}) do
                    args[#args+1] = v
                end
                job = mp.command_native_async({name='subprocess', playback_only=false,
                    capture_stdout=true, capture_stderr=true, args=args}, finish)
            end
            if e.youtube_id then
                -- Fetch only the poster image, never the video or audio streams.
                job = mp.command_native_async({name='subprocess', playback_only=false,
                    capture_stdout=true, capture_stderr=true,
                    args={'curl', '--fail', '--silent', '--show-error', '--location',
                        '--connect-timeout', '5', '--max-time', '15', '--output', image,
                        'https://i.ytimg.com/vi/' .. e.youtube_id .. '/hqdefault.jpg'}},
                    function(success, result)
                        if success and result and result.status == 0 then convert(image)
                        else finish(false, result) end
                    end)
            else
                convert(e.path, e.position)
            end
            return
        end
    end
end
-- Durations are cached separately from thumbnails; playback never waits for them.
pump_duration = function()
    if duration_job or not active then return end
    local candidates = {shown[selected]}
    for i = first, math.min(#shown, first + rows - 1) do candidates[#candidates+1] = shown[i] end
    for _, e in ipairs(candidates) do
        if not e.duration and not duration_failed[e.thumb] and (e.youtube_id or e.local_file) then
            local args
            if e.youtube_id then
                args = {'yt-dlp', '--ignore-config', '--no-playlist', '--skip-download',
                    '--socket-timeout', '8', '--retries', '0', '--extractor-retries', '0',
                    '--print', '%(duration)s', '--', 'https://www.youtube.com/watch?v=' .. e.youtube_id}
            else
                args = {'ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'default=noprint_wrappers=1:nokey=1', e.path}
            end
            duration_job = mp.command_native_async({name='subprocess', playback_only=false,
                capture_stdout=true, capture_stderr=true, args=args}, function(success, result)
                duration_job = nil
                if duration_timer then duration_timer:kill(); duration_timer = nil end
                local value = success and result and result.status == 0 and tonumber(result.stdout)
                if value and value > 0 then
                    e.duration = value
                    local f = io.open(e.thumb .. '.duration', 'w')
                    if f then f:write(tostring(value)); f:close() end
                else duration_failed[e.thumb] = true end
                render()
            end)
            duration_timer = mp.add_timeout(30, function()
                if duration_job then mp.abort_async_command(duration_job) end
            end)
            return
        end
    end
end
local function move(n)
    if #shown == 0 then return end
    local now = mp.get_time()
    if now - last_move < 0.10 then return end
    last_move = now
    selected = ((selected - 1 + n) % #shown) + 1
    render()
end
local function edit_query(value)
    if value == query then return end
    query = value
    filter()
    render()
end
local function resume()
    local e = shown[selected]
    if e then close(); mp.commandv('loadfile', e.path) end
end
local function bind(key, fn, repeatable)
    local name = 'watch-later-thumbs-' .. #bindings
    bindings[#bindings+1] = name
    mp.add_forced_key_binding(key, name, fn, {repeatable = repeatable, complex = key == 'any_unicode'})
end
local function open()
    if active then close(); return end
    local dir = mp.get_property('current-watch-later-dir')
    if not dir then mp.osd_message('No watch-later directory'); return end
    local result = mp.command_native({name='subprocess', playback_only=false, args={'mkdir', '-p', cache}})
    if not result or result.status ~= 0 then mp.osd_message('Cannot create thumbnail cache'); return end
    entries = {}
    for _, name in ipairs(utils.readdir(dir, 'files') or {}) do
        local filename = utils.join_path(dir, name)
        local f = io.open(filename)
        if f then
            local data = f:read('*a'); f:close()
            local path = data:match('^# ([^\r\n]+)')
            if path and path ~= 'redirect entry' then
                local info = utils.file_info(filename)
                local source = not path:find('://', 1, true) and utils.file_info(path)
                local pos = tonumber(data:match('\nstart=([%d%.]+)')) or 0
                -- This mpv fork saves the resolved media title as a comment.
                local title = data:match('\n# title: *([^\r\n]+)')
                if not title or title:match('^%s*$') then
                    title = select(2, utils.split_path(path))
                end
                local yt = youtube_id(path)
                entries[#entries+1] = {path=path, title=title, position=pos, mtime=info.mtime,
                    local_file=source and source.is_file, youtube_id=yt,
                    thumb=utils.join_path(cache, (yt and ('youtube-' .. yt) or (name .. '-' .. tostring(info.mtime))) .. '-240x136.bgra')}
            end
        end
    end
    table.sort(entries, function(a,b) return a.mtime > b.mtime end)
    failed = {} -- Retry temporary network failures when reopening the menu.
    last_move = -math.huge
    query = ''; filter(); active = true
    bind('ESC', close); bind('ENTER', resume)
    bind('UP', function() move(-1) end, true); bind('DOWN', function() move(1) end, true)
    bind('Ctrl+p', function() move(-1) end, true); bind('Ctrl+n', function() move(1) end, true)
    bind('PGUP', function() move(-rows) end, true); bind('PGDWN', function() move(rows) end, true)
    bind('WHEEL_UP', function() move(-1) end, true); bind('WHEEL_DOWN', function() move(1) end, true)
    bind('BS', function() edit_query((query:gsub('[%z\1-\127\194-\244][\128-\191]*$', ''))) end, true)
    bind('Ctrl+BS', function() edit_query((query:gsub('%s+$', ''):gsub('%S+$', ''))) end, true)
    bind('any_unicode', function(t) if t.event ~= 'up' and t.key_text then edit_query(query .. t.key_text) end end)
    bind('MBTN_LEFT', function()
        if not layout then return end
        local x,y = mp.get_mouse_pos()
        if x >= layout.scroll_x and x <= layout.scroll_x + layout.scroll_w and
            y >= layout.y and y <= layout.y + layout.scroll_h and #shown > 0 then
            local fraction = (y - layout.y) / layout.scroll_h
            selected = math.max(1, math.min(#shown, math.floor(fraction * (#shown-1)) + 1))
            render()
            return
        end
        if x > layout.right then return end
        local slot = math.floor((y-layout.y)/layout.rh)
        if slot >= 0 and slot < rows and shown[first+slot] then selected=first+slot; resume() end
    end)
    render()
end
mp.add_key_binding('Alt+w', 'watch-later-thumbnails', open)
mp.observe_property('osd-dimensions', 'native', function() if active then render() end end)
mp.register_event('shutdown', function()
    if job then mp.abort_async_command(job) end
    if duration_job then mp.abort_async_command(duration_job) end
end)
