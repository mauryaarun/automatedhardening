A cheat sheet for some common Bash shell commands and with examples:

### File and Directory Management:

1. **List Files and Directories**:
   ```bash
   ls
   ```
2. **Change Directory**:
   ```bash
   cd /path/to/directory
   ```
3. **Create Directory**:
   ```bash
   mkdir directory_name
   ```
4. **Remove File**:
   ```bash
   rm file_name
   ```
5. **Remove Directory (and its contents)**:
   ```bash
   rm -r directory_name
   ```
6. **Copy File**:
   ```bash
   cp source_file destination
   ```
7. **Move/Rename File**:
   ```bash
   mv old_name new_name
   ```

### File Manipulation:

8. **Create a New File or Edit an Existing File**:
   ```bash
   nano filename.txt
   ```
9. **Concatenate and Display File Contents**:
   ```bash
   cat file.txt
   ```

### Working with Text:

10. **Search Text in a File**:
    ```bash
    grep "pattern" file.txt
    ```
11. **Find and Replace Text in Files**:
    ```bash
    sed 's/old_text/new_text/g' file.txt
    ```
12. **Count Lines, Words, and Characters in a File**:
    ```bash
    wc file.txt
    ```

### Process Management:

13. **List Running Processes**:
    ```bash
    ps
    ```
14. **Kill a Process by PID**:
    ```bash
    kill PID
    ```

### Redirection and Pipes:

15. **Redirect Output to a File**:
    ```bash
    command > output.txt
    ```
16. **Append Output to a File**:
    ```bash
    command >> output.txt
    ```
17. **Pipe Output to Another Command**:
    ```bash
    command1 | command2
    ```

### Permissions:

18. **Change File Permissions**:
    ```bash
    chmod permissions file
    ```
19. **Change File Owner**:
    ```bash
    chown new_owner file
    ```

### Environment and Variables:

20. **Set Environment Variable**:
    ```bash
    export VAR_NAME=value
    ```
21. **Access Environment Variable**:
    ```bash
    echo $VAR_NAME
    ```

### Conditional Statements:

22. **If Statement**:
    ```bash
    if [ condition ]; then
        # commands
    fi
    ```

23. **Case Statement**:
    ```bash
    case $variable in
        pattern1) commands1;;
        pattern2) commands2;;
        *) default_commands;;
    esac
    ```

### Loops:

24. **For Loop**:
    ```bash
    for item in list; do
        # commands
    done
    ```

25. **While Loop**:
    ```bash
    while [ condition ]; do
        # commands
    done
    ```

### File and Directory Navigation:

26. **Go to Home Directory**:
    ```bash
    cd ~
    ```
27. **Go Up One Directory**:
    ```bash
    cd ..
    ```
28. **List Files in Long Format with Hidden Files**:
    ```bash
    ls -la
    ```

### File Permissions:

29. **Change Directory Permissions Recursively**:
    ```bash
    chmod -R permissions directory
    ```
30. **Change the Owner and Group of a File or Directory**:
    ```bash
    chown new_owner:new_group file_or_directory
    ```

### File Compression:

31. **Create a Tar Archive**:
    ```bash
    tar -cvf archive.tar files_or_directories
    ```
32. **Extract a Tar Archive**:
    ```bash
    tar -xvf archive.tar
    ```
33. **Compress a File or Directory with gzip**:
    ```bash
    gzip file_or_directory
    ```

### User Management:

34. **Add a User**:
    ```bash
    useradd username
    ```
35. **Change User Password**:
    ```bash
    passwd username
    ```

### Networking:

36. **Check IP Address**:
    ```bash
    ifconfig
    ```
37. **Ping a Host**:
    ```bash
    ping hostname
    ```

### Command History:

38. **View Command History**:
    ```bash
    history
    ```
39. **Repeat a Command by Number**:
    ```bash
    !number
    ```

### Variables and Arithmetic:

40. **Perform Arithmetic Operations**:
    ```bash
    result=$((5 + 3))
    echo $result
    ```
41. **Concatenate Strings**:
    ```bash
    concatenated="Hello, " + "World!"
    ```

### Functions:

42. **Define a Function**:
    ```bash
    my_function() {
        # commands
    }
    ```
43. **Call a Function**:
    ```bash
    my_function
    ```

### Input and Output:

44. **Read User Input**:
    ```bash
    read -p "Enter something: " user_input
    ```
45. **Output to STDERR**:
    ```bash
    echo "Error message" >&2
    ```

### Miscellaneous:

46. **Current Shell Process ID**:
    ```bash
    echo $$ 
    ```

47. **Get Date and Time**:
    ```bash
    date
    ```
### Command Substitution:

48. **Capture Command Output into a Variable**:
   ```bash
   result=$(command)
   ```
49. **Execute a Command Within a String**:
   ```bash
   echo "Today is $(date)"
   ```

### Conditional Ternary Operator:

50. **Use a Conditional Ternary Operator**:
   ```bash
   result=$((condition ? value_if_true : value_if_false))
   ```

### Math Operations:

51. **Perform Floating-Point Math**:
   ```bash
   result=$(bc -l <<< "scale=2; 3.14 * 2")
   echo $result
   ```

### Logical Operators:

52. **Logical AND**:
   ```bash
   if [ $condition1 -eq 1 ] && [ $condition2 -eq 2 ]; then
       # commands
   fi
   ```

53. **Logical OR**:
   ```bash
   if [ $condition1 -eq 1 ] || [ $condition2 -eq 2 ]; then
       # commands
   fi
   ```

### Arrays:

54. **Declare an Array**:
   ```bash
   my_array=("item1" "item2" "item3")
   ```

55. **Access Elements in an Array**:
   ```bash
   element=${my_array[1]}
   ```

56. **Loop Through Array Elements**:
   ```bash
   for item in "${my_array[@]}"; do
       echo $item
   done
   ```

### String Manipulation:

57. **String Length**:
   ```bash
   length=${#my_string}
   ```

58. **Substring Extraction**:
   ```bash
   substring=${my_string:2:5}  # Start at index 2, length 5
   ```

### Command Line Arguments:

59. **Access Command Line Arguments**:
   ```bash
   scriptname arg1 arg2 arg3
   # Inside the script:
   arg1=$1
   arg2=$2
   ```

### Environment Variables:

60. **List All Environment Variables**:
   ```bash
   env
   ```

61. **Check if a Variable is Set**:
   ```bash
   if [ -z "$variable" ]; then
       echo "Variable is not set"
   fi

### File Testing:

62. **Check if a File Exists**:
   ```bash
   if [ -e file.txt ]; then
       # File exists
   fi
   ```

63. **Check if a File is a Directory**:
   ```bash
   if [ -d directory_name ]; then
       # It's a directory
   fi
   ```

