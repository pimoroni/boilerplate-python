printf "\nOutstanding substitutions:\n"
grep -Irn --color "__[A-Z:]*__"
grep -Irn --color "PROJECT_NAME"

printf "\nOutstanding directory renames:\n"
find . -regex ".*__[A-Z]*__"
