#!/bin/bash
shopt -s extglob


function validate_name() {
    [[ $1 =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
}


function Create_Table(){
read -p "Enter Table name: " TBName ;
 TBName="${TBName##+([[:space:]])}"
    TBName="${TBName%%+([[:space:]])}"


if validate_name $TBName 
	then 
		
		if  [ ! -e $databases/$DBName/$TBName ] 
		then
			touch "$databases/$DBName/$TBName"
			echo "Table '$TBName' created successfully"
		else 
			echo "Table '$TBName' already exist"
			cd "$databases/$DBName/$TBName"
		fi
		read -p "Enter columns number: " ColNum ;
		if [[ "$ColNum" =~ ^[0-9]+$ ]]; then
		for (( i=1; i<=ColNum; i++ )) do
    			read -p "Enter column $i name: " ColName
    			if [[ "$ColName" =~ ^[a-zA-Z]+$ ]]; then
        			read -p "Enter column $i type(int/str): " ColType
        			echo -n "$ColName" >> "$databases/$DBName/$TBName"
        			if [[ $i -lt $ColNum ]]; then
            				echo -n ":" >> "$databases/$DBName/$TBName"
        			else
            				echo "" >> "$databases/$DBName/$TBName"   
        			fi
    			else
        			echo "Invalid column name"
        			((i--)) 
    			fi
		done	
		else
 			   echo "Not a valid Colomn number"
		fi
		read -p "Primary Key column name: " pk
		sed -i "1s/\b$pk\b/$pk (pk)/" "$databases/$DBName/$TBName" 
else
	echo 'Invalid TBName' 
fi			
}

function List_Tables() {
    ls "$databases/$DBName"
}

function Drop_Table() {
    read -p "Enter table name: " TBName
       TBName="${TBName##+([[:space:]])}"
    TBName="${TBName%%+([[:space:]])}"
    if [[ -f "$databases/$DBName/$TBName" ]]; then
        rm "$databases/$DBName/$TBName"
        echo "Table deleted successfully"
    else
        echo " Table not found"
    fi
}

function Insert_into_Table(){
    read -p "Enter table name: " TBName
      TBName="${TBName##+([[:space:]])}"
    TBName="${TBName%%+([[:space:]])}"
    if [[ ! -f "$databases/$DBName/$TBName" ]]; then
        echo "Table '$TBName' does not exist."
    else
    
    
    header=$(head -n 1 "$databases/$DBName/$TBName")
    IFS=':' read -a columns <<< "$header"

    record=""
    for col in "${columns[@]}"; do
        read -p "Enter value for '$col': " value
        record+="$value:"
    done
    record=${record::-1}
    echo "$record" >> "$databases/$DBName/$TBName"
    echo "Record inserted successfully into '$TBName'."
   fi
}

function Connect_To_Databases(){
DBName=$1
select choice in Create_Table List_Tables Drop_Table Insert_into_Table Select_From_Table Delete_From_Table Update_Table exit
do
	case $choice in 
	
		"Create_Table")
			
			Create_Table 
			;;
		
		"List_Tables")
			 List_Tables
			;;
		"Drop_Table")
			Drop_Table 
			;;
		"Insert_into_Table")
			Insert_into_Table
			;;
		"Select_From_Table")
			echo "hello2" 
			;;
		"Delete_From_Table")
		
			echo "hello3" 
			;;
		"Update_Table")
			echo "hello3" 
			;;
		"exit")
			break
			;;
		*)
			echo "Unknown entry" 
			;;
	esac
done
}
#Connect_To_Databases $1
               
#mkdir 
databases="databases"
mkdir -p "$databases"
#chmod u+x databases/*

select choice in Create_Database List_Databases Connect_To_Databases Drop_Database exit
do
	case $choice in 
	
		"Create_Database")
			read -p "Enter DB name: " DBName ;
			if validate_name $DBName
			then
				if  [ ! -e $databases/$DBName ] 
				then 
					mkdir -p $databases/$DBName 
					Connect_To_Databases "$DBName"
				else 
			 		echo "$DBName database already exist"
			 		cd $databases/$DBName 
			 		Connect_To_Databases "$DBName"
				fi
			else
				echo "Invalid database name"
			fi
			;;
		"List_Databases")
			 if  [ -e $databases ] 
			 then
				ls "$databases" 
			else 
			 	echo "$databases database does not exist"
			 fi
			  ;;
		"Connect_To_Databases")
			read -p "Enter DB name: " DBName
			if [ -e "$databases/$DBName" ]; then
				Connect_To_Databases "$DBName"
			else
				echo "Database '$DBName' does not exist."
			fi ;;
		"Drop_Database")
			read -p "Enter DB name: " DBName ;
			if  [ -e $databases/$DBName ] ;
				then 
					rm -r $databases/$DBName 
			else
				echo "there is no $DBName  "
			fi ;;
			#rm -r "$databases" ;;
		"exit")
			break ;;
		*)
			echo "Unknown entry" ;;
	esac
done













