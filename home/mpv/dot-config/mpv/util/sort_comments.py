#!/usr/bin/env python3
import json
import sys
import argparse
from collections import defaultdict


def load_comments(filepath):
    """Load comments from JSON file."""
    with open(filepath, "r", encoding="utf-8") as f:
        data = json.load(f)
    return data.get("comments", [])


def build_comment_tree(comments):
    """Build a tree structure of comments with their replies."""
    # Separate root comments and replies
    root_comments = []
    replies_by_parent = defaultdict(list)

    for comment in comments:
        if comment["parent"] == "root":
            root_comments.append(comment)
        else:
            replies_by_parent[comment["parent"]].append(comment)

    return root_comments, replies_by_parent


def format_comment(comment, indent=0):
    """Format a single comment with indentation."""
    indent_str = "    " * indent
    author = comment["author"]
    likes = comment["like_count"]
    text = comment["text"]

    # Wrap text to 80 chars, accounting for indentation
    max_width = 80 - len(indent_str) - 2  # -2 for the "  " prefix
    wrapped_lines = []

    for line in text.split("\n"):
        while len(line) > max_width:
            # Find last space before max_width
            split_pos = line.rfind(" ", 0, max_width)
            if split_pos == -1:
                split_pos = max_width
            wrapped_lines.append(line[:split_pos])
            line = line[split_pos:].lstrip()
        wrapped_lines.append(line)

    # Join with proper indentation
    wrapped_text = f"\n{indent_str}  ".join(wrapped_lines)

    return f"{indent_str}[{likes} likes] @{author}:\n{indent_str}  {wrapped_text}\n"


def print_comment_tree(comment, replies_by_parent, indent=0, sort_replies=False):
    """Recursively print a comment and its replies."""
    output = format_comment(comment, indent)

    # Get replies for this comment
    replies = replies_by_parent.get(comment["id"], [])

    # Optionally sort by likes
    if sort_replies:
        replies = sorted(replies, key=lambda x: x["like_count"], reverse=True)

    for reply in replies:
        output += print_comment_tree(reply, replies_by_parent, indent + 1, sort_replies)

    return output


def main():
    parser = argparse.ArgumentParser(description="Display YouTube comments")
    parser.add_argument("json_file", help="Path to the JSON file with comments")
    parser.add_argument(
        "--sort",
        choices=["likes", "time", "none"],
        default="none",
        help="Sort order: likes, time, or none (default, use yt-dlp order)",
    )

    args = parser.parse_args()

    # Load and process comments
    comments = load_comments(args.json_file)
    root_comments, replies_by_parent = build_comment_tree(comments)

    # Sort root comments based on argument
    if args.sort == "likes":
        root_comments_sorted = sorted(
            root_comments, key=lambda x: x["like_count"], reverse=True
        )
        sort_replies = True
    elif args.sort == "time":
        root_comments_sorted = sorted(
            root_comments, key=lambda x: x["timestamp"], reverse=True
        )
        sort_replies = True
    else:  # 'none'
        root_comments_sorted = root_comments
        sort_replies = False

    # Generate output
    output = "=" * 80 + "\n"
    output += "YOUTUBE COMMENTS\n"
    output += "=" * 80 + "\n\n"

    for comment in root_comments_sorted:
        output += print_comment_tree(
            comment, replies_by_parent, sort_replies=sort_replies
        )
        output += "-" * 80 + "\n"

    # Print to stdout (can be piped to less)
    print(output)


if __name__ == "__main__":
    main()
