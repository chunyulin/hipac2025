import os

SUBMISSIONS_DIR = "submissions"
SUMMARY_FILE = "summary.md"

def count_lines(file_path):
    """Returns the number of lines in a file."""
    with open(file_path, "r", encoding="utf-8") as f:
        return sum(1 for _ in f)

def process_submissions():
    summary_content = "# Submission Summary\n\n"

    if not os.path.exists(SUBMISSIONS_DIR):
        summary_content += "No submissions found.\n"
    else:
        for student_folder in sorted(os.listdir(SUBMISSIONS_DIR)):
            student_path = os.path.join(SUBMISSIONS_DIR, student_folder)

            if os.path.isdir(student_path):  # Ensure it's a folder
                summary_content += f"## {student_folder}\n"
                
                for file in sorted(os.listdir(student_path)):
                    file_path = os.path.join(student_path, file)

                    if os.path.isfile(file_path):  # Ignore subdirectories
                        num_lines = count_lines(file_path)
                        summary_content += f"- `{file}`: {num_lines} lines\n"
                
                summary_content += "\n"  # Extra spacing

    with open(SUMMARY_FILE, "w", encoding="utf-8") as f:
        f.write(summary_content)

    print("Summary report generated.")

if __name__ == "__main__":
    process_submissions()
