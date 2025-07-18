#!/bin/bash

# Retrieve the current Git user name and email address
git_user_name=$(git config user.name)
git_user_email=$(git config user.email)

friday="5"
saturday="6"
sunday="7"

################################################

# You can change these variables to change the start and end dates of the commits
start_date="2024-01-01"
end_date="2024-06-06"

# You can choose to exclude certain days of the week from having commits. You can exclude up to 3 days.
exclude_days=("$saturday" "$sunday")

java="java"
python="py"
typescript="ts"
javascript="js"

languages=("$java" "$python" "$typescript" "$javascript")

# Other examples
# exclude_days=("$friday" "$saturday")
# exclude_days=("$friday" "$saturday" "$sunday")

################################################

# Set the current date as "start date". This will change as we loop through each day of the year
current_date="$start_date"

# Loop through each day of the year
while [ "$current_date" != "$end_date" ]; do

  # Get the day of the week (1-7, where 1 is Monday and 7 is Sunday)
  day_of_week=$(date -jf "%Y-%m-%d" "$current_date" +"%u")

  # Check if the day is not in the exclude_days array
  if [ "$day_of_week" != "${exclude_days[0]}" ] && [ "$day_of_week" != "${exclude_days[1]}" ] && [ "$day_of_week" != "${exclude_days[2]}" ]; then
    # Generate a random number between 1 and 100
    random_num=$((RANDOM % 100 + 1))

    # Set num_changes based on the probability distribution
    if [ "$random_num" -le 10 ]; then
      num_changes=0
    elif [ "$random_num" -le 40 ]; then
      num_changes=1
    elif [ "$random_num" -le 80 ]; then
      num_changes=2
    elif [ "$random_num" -le 90 ]; then
      num_changes=3
    else
      num_changes=4
    fi

    random_lang_index=$((RANDOM % ${#languages[@]}))
    language=${languages[$random_lang_index]}

    if [ ! -d "$language" ]; then
      mkdir "$language"
    fi

    # Make the specified number of changes
    for ((i = 1; i <= num_changes; i++)); do
      # Add a character to the text file
      filename="$current_date.$language"
      touch "$language/$filename"

      # Add more substantial content based on the language
      case "$language" in
        "java")
          echo 'public class master { public static void master(String[] args) { System.out.println("Hello, World!"); } }' > "$language/$filename"
          echo 'class Helper { void help() { System.out.println("Helping..."); } }' >> "$language/$filename"
          ;;
        "py")
          echo 'print("Hello, World!")' > "$language/$filename"
          echo 'def helper(): print("Helping...")' >> "$language/$filename"
          ;;
        "ts")
          echo 'console.log("Hello, World!");' > "$language/$filename"
          echo 'function helper() { console.log("Helping..."); }' >> "$language/$filename"
          ;;
        "js")
          echo 'console.log("Hello, World!");' > "$language/$filename"
          echo 'function helper() { console.log("Helping..."); }' >> "$language/$filename"
          ;;
      esac

      # Add the file to Git
      git add "$language/$filename"

      # Set the commit date with the correct format
      commit_date="${current_date}T00:00:00"

      # Commit the changes to Git with the current date as the commit date and set the Git user name and email
      GIT_AUTHOR_DATE="$commit_date" \
      GIT_COMMITTER_DATE="$commit_date" \
      GIT_AUTHOR_NAME="$git_user_name" \
      GIT_AUTHOR_EMAIL="$git_user_email" \
      GIT_COMMITTER_NAME="$git_user_name" \
      GIT_COMMITTER_EMAIL="$git_user_email" \
      git commit -m "Change $i on $current_date"
    done
  fi

  # Increment the date by one day
  current_date=$(date -jf "%Y-%m-%d" -v+1d "$current_date" +"%Y-%m-%d")

done

# git push origin master
echo -e "\033[32m\n########\nDone! Go to your Github profile and enjoy your greens!\n#########\033[0m"
