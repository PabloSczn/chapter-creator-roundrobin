#!/bin/sh

#Pablo Sanchez Narro
#Last date of modification: 13/11/2021


echo "Creating Docker containers..."

#-------------- INITIALIZE EVERYTHING --------------------------------------
#Create docker 1 in port 80:80
sudo docker run -d --name Docker1 -p 80:80 nginx > /dev/null
echo "Docker 1 created..."

#Create docker 2 in port 81:80
sudo docker run -d --name Docker2 -p 81:80 nginx > /dev/null
echo "Docker 2 created..."

#Create docker 3 in port 82:80
sudo docker run -d --name Docker3 -p 82:80 nginx > /dev/null
echo "Docker 3 created..."

#/dev/null -> Not to show output

#Loading files to Docker 1
sudo docker cp Docker1 Docker1:Docker1
echo "Loaded files to Docker1"

#Loading files to Docker 2
sudo docker cp Docker2 Docker2:Docker2
echo "Loaded files to Docker2"

#Loading files to Docker3
sudo docker cp Docker3 Docker3:Docker3
echo "Loaded files to Docker3"


#----------- SORT FILES --------------- MATRIC WITH REMAINDER 2 -------------

#Allowing execution in files Docker 1----------------------------
sudo docker exec Docker1 chmod +x Docker1/*.txt 

#Store text files sorted in a temp text file
#Sorting for files is Shortest Job Next
sudo docker exec Docker1 wc -c Docker1/*.txt | sort -n > temp.txt

#Only store the name of the text files
sudo cut -d '/' -f 2 temp.txt > filesSortedD1.txt

#Delete last line (which only outputs the total length  of the files)
sudo sed -i "\$d" filesSortedD1.txt
sudo rm temp.txt

#Save the files sorted in variables for later use
INDEX=1
while read -r ARRAY
do 
	eval DOCKERONE${INDEX}='${ARRAY}'   
	INDEX=$(( INDEX+1 ))
done < filesSortedD1.txt

#Allowing execution in files Docker 2-------------------------------------
sudo docker exec Docker2 chmod +x Docker2/*.txt 

#Store text files names in a text file
#It is not sorted - (First Come First Served)
sudo docker exec Docker2 wc -c Docker2/*.txt > temp.txt

#Only store the name of the text files
sudo cut -d '/' -f 2 temp.txt > filesD2.txt
sudo sed -i "\$d" filesD2.txt
sudo rm temp.txt

#Save the files sorted in variables for later use
INDEX=1
while read -r ARRAY
do 
        eval DOCKERTWO${INDEX}='${ARRAY}'   
        INDEX=$(( INDEX+1 ))
done < filesD2.txt


#Allowing execution in files Docker 3----------------------------------------
sudo docker exec Docker3 chmod +x Docker3/*.txt 

#Store text files sorted in a temp text file
#Sorting for files is Shortest Job Next
sudo docker exec Docker3 wc -c Docker3/*.txt | sort -n > temp.txt

#Only store the name of the text files
sudo cut -d '/' -f 2 temp.txt > filesSortedD3.txt
sudo sed -i "\$d" filesSortedD3.txt
sudo rm temp.txt

#Save the files sorted in variables for later use
INDEX=1
while read -r ARRAY
do 
        eval DOCKERTHREE${INDEX}='${ARRAY}'   
        INDEX=$(( INDEX+1 ))
done < filesSortedD3.txt



#-------------------- HOW MANY FILES IN EACH DOCKER --------------------------
#Docker1 ----------------------------------------------
#Flag to stop the counter
FLAG=0

#Number to change the variable to check if it exists
IndexD1=0

#Number of files in Docker1
N_FilesD1=0

#Initialize the text files
#Temporary text file
echo "Temporal texts" > TempText.txt
echo "Here will appear the contents of D1 txt files" > TextsD1.txt

#While the counter is not stopped
while [ $FLAG -lt 1 ];
 do
      #Use the temporary text file
      #If TextsD1.txt doesnt change, the variable didn't exist
      cat TextsD1.txt > TempText.txt

      IndexD1=`expr $IndexD1 + 1`
      TEXT=\$"{DOCKERONE${IndexD1}}"\
      
      eval cat Docker1/$TEXT > TextsD1.txt 2> /dev/null
      

      #If TextsD1.txt doesnt change, the variable didn't exist
      if cmp -s TempText.txt TextsD1.txt;
       then
        N_FilesD1=`expr $N_FilesD1 - 1`
        FLAG=1
       else
        N_FilesD1=`expr $N_FilesD1 + 1`
      fi
 done

sudo rm TextsD1.txt
sudo rm TempText.txt


#Docker2 ----------------------------------------------------------------
#Flag to stop the counter
FLAG=0

#Number to change the variable to check if it exists
IndexD2=0

#Number of files in Docker1
N_FilesD2=0

#Initialize the text files
#Temporary text file
echo "Temporal texts" > TempText.txt
echo "Here will appear the contents of D1 txt files" > TextsD2.txt


while [ $FLAG -lt 1 ];
 do
      #Use the temporary text file
      #If TextsD2.txt doesnt change, the variable didn't exist
      cat TextsD2.txt > TempText.txt

      IndexD2=`expr $IndexD2 + 1`
      TEXT=\$"{DOCKERTWO${IndexD2}}"\
      
      eval cat Docker2/$TEXT > TextsD2.txt 2> /dev/null
      

      #If TextsD2.txt doesnt change, the variable didn't exist
      if cmp -s TempText.txt TextsD2.txt;
       then
        N_FilesD2=`expr $N_FilesD2 - 1`
        FLAG=1
       else
        N_FilesD2=`expr $N_FilesD2 + 1`
      fi
 done


sudo rm TextsD2.txt
sudo rm TempText.txt



#Docker3 ------------------------------------------------------
#Flag to stop the counter
FLAG=0

#Number to change the variable to check if it exists
IndexD3=0

#Number of files in Docker1
N_FilesD3=0

#Initialize the text files
#Temporary text file
echo "Temporal texts" > TempText.txt
echo "Here will appear the contents of D1 txt files" > TextsD3.txt


while [ $FLAG -lt 1 ];
 do
      #Use the temporary text file
      #If TextsD3.txt doesnt change, the variable didn't exist
      cat TextsD3.txt > TempText.txt

      IndexD3=`expr $IndexD3 + 1`
      TEXT=\$"{DOCKERTHREE${IndexD3}}"\
      
      eval cat Docker3/$TEXT > TextsD3.txt 2> /dev/null
      

      #If TextsD3.txt doesnt change, the variable didn't exist
      if cmp -s TempText.txt TextsD3.txt;
       then
        N_FilesD3=`expr $N_FilesD3 - 1`
        FLAG=1
       else
        N_FilesD3=`expr $N_FilesD3 + 1`
      fi
 done

sudo rm TextsD3.txt
sudo rm TempText.txt

#Delete the file texts that we don't need anymore
sudo rm filesSortedD1.txt
sudo rm filesD2.txt
sudo rm filesSortedD3.txt

#Delete GAMES_OF_DOCKERS in case already exists in our PC
#So our program doesn't append the text to an existing file
sudo rm GAMES_OF_DOCKERS.txt 2> /dev/null

#-------------------------------------- ROUND ROBIN --------------------------------------------------


echo "Beginning text creation GAMES_OF_DOCKERS.txt..."
#To keep track of the files of the dockers
filesD1=1
filesD2=1
filesD3=1

#To show the output to the user ---------------------------------------
#If the counters of files are less or equals to the number of total files
while [ "$filesD1" -le "$N_FilesD1" -o "$filesD2" -le "$N_FilesD2" -o "$filesD3" -le "$N_FilesD3" ];
 do
    #If the counter remains less or equals to the number of total files
    if [ "$filesD1" -le "$N_FilesD1" ];
    then
    #Variable to find what file to append
    TextsD1=\$"{DOCKERONE${filesD1}}"\
    eval echo $TextsD1 > delete.txt
    #Append file
    eval cat Docker1/$TextsD1 >> GAMES_OF_DOCKERS.txt 2> /dev/null
    echo "Loading $filesD1 text from 1st Docker container..." 2> /dev/null
    #Increasing the counter to change the text to append
    filesD1=`expr $filesD1 + 1`
            #Only if the docker still have files
            if [ "$filesD1" -le "$N_FilesD1" ];
            then
                #Variable to find what file to append
                _TextsD1=\$"{DOCKERONE${filesD1}}"\
                eval echo $_TextsD1 > delete.txt
                #Append file
                eval cat Docker1/$_TextsD1 >> GAMES_OF_DOCKERS.txt 2> /dev/null
                echo "Loading $filesD1 text from 1st Docker container..." 2> /dev/null
                filesD1=`expr $filesD1 + 1`
            fi
    fi


    #If the counter remains less or equals to the number of total files
    if [ "$filesD2" -le "$N_FilesD2" ];
    then
    #Variable to find what file to append
    TextsD2=\$"{DOCKERTWO${filesD2}}"\
    eval echo $TextsD2 > delete.txt
    #Append file
    eval cat Docker2/$TextsD2 >> GAMES_OF_DOCKERS.txt 2> /dev/null
    echo "Loading $filesD2 text from 2nd Docker container..." 2> /dev/null
    filesD2=`expr $filesD2 + 1`
            #Only if the docker still have files    
            if [ "$filesD2" -le "$N_FilesD2" ];
            then
                #Variable to find what file to append
                _TextsD2=\$"{DOCKERTWO${filesD2}}"\
                eval echo $_TextsD2 > delete.txt
                #Append file
                eval cat Docker2/$_TextsD2 >> GAMES_OF_DOCKERS.txt 2> /dev/null
                echo "Loading $filesD2 text from 2nd Docker container..." 2> /dev/null
                filesD2=`expr $filesD2 + 1`
            fi
    fi

    #If the counter remains less or equals to the number of total files
    if [ "$filesD3" -le "$N_FilesD3" ];
    then
    #Variable to find what file to append
    TextsD3=\$"{DOCKERTHREE${filesD3}}"\
    eval echo $TextsD3 > delete.txt
    #Append file
    eval cat Docker3/$TextsD3 >> GAMES_OF_DOCKERS.txt 2> /dev/null
    echo "Loading $filesD3 text from 3rd Docker container..." 2> /dev/null
    filesD3=`expr $filesD3 + 1`
            #Only if the docker still have files
            if [ "$filesD3" -le "$N_FilesD3" ];
            then
                #Variable to find what file to append
                _TextsD3=\$"{DOCKERTHREE${filesD3}}"\
                eval echo $_TextsD3 > delete.txt
                #Append file
                eval cat Docker3/$_TextsD3 >> GAMES_OF_DOCKERS.txt 2> /dev/null
                echo "Loading $filesD3 text from 3rd Docker container..." 2> /dev/null
                filesD3=`expr $filesD3 + 1`
            fi
     fi
 done


sudo rm delete.txt

#----------------------------------------- INTERACTION WITH THE USER ---------------------------------------------------------

echo "Finished loading text..."

#Keep asking for user input
while true
do
    #Read chapter?
    while true
    do
    #Ask the user
    read -r -p "Would you like to read Game of Dockers Chapter? [Y/n] " readChapter
     
    case $readChapter in
        [yY][eE][sS]|[yY])  #In case Yes
        cat GAMES_OF_DOCKERS.txt    #Show the chapter

        #Spaces
        echo
        echo
    break
    ;;
        [nN][oO]|[nN])  #In case No
    #Exit loop
    break
        ;;
        *)  #Rest

        #Re-enter the loop
        echo "Invalid input..."
        ;;
    esac
    done
    
    #Remove text?
    while true
    do
    #Ask the user
    read -r -p "Would you like to remove any text from Game of Dockers? [Y/n] " readRemove
     
    case $readRemove in
        [yY][eE][sS]|[yY])  #In case Yes
        #Ask what text to remove
        read -r -p "What text you want to remove? " textRemove
        #Remove the text
        sed -i -e "s/$textRemove//g" GAMES_OF_DOCKERS.txt
    break
    ;;
        [nN][oO]|[nN])  #In case No
    #Exit loop
    break
    ;;
        *)  #Invalid input
        
        #Re-enter the loop
        echo "Invalid input..."
    ;;
    esac
    done
    
    #Add text?
    while true
    do
    #Ask the user
    read -r -p "Would you like to add any text to Game of Dockers? [Y/n] " readAdd
     
    case $readAdd in
        [yY][eE][sS]|[yY])  #In case Yes
        #Ask what text to add
        read -r -p "What text you want to add? " textAdd
        #Add text
        echo $textAdd >> GAMES_OF_DOCKERS.txt
    
    break
    ;;
        [nN][oO]|[nN])  #In case No
    #Exit loop
    break
    ;;
        *)  #Invalid input
        
        #Re-enter the loop
        echo "Invalid input..."
    ;;
    esac
    done
    
    #Terminate the program?
    while true
    do
    #Ask the user
    read -r -p "Would you like to terminate the program? [Y/n] " terminateProgram
     
    case $terminateProgram in
        [yY][eE][sS]|[yY])  #In case Yes

    	#Stop dockers
    	sudo docker stop Docker1 > /dev/null
    	sudo docker stop Docker2 > /dev/null
    	sudo docker stop Docker3 > /dev/null
    
    	#Delete dockers
    	sudo docker rm Docker1 > /dev/null
    	sudo docker rm Docker2 > /dev/null
    	sudo docker rm Docker3 > /dev/null
        
        #Terminate program
        exit
    ;;
        [nN][oO]|[nN])  #In case No
    
    #Go to the beginning of the loop (first while loop)
    break
    ;;
        *)  #Invalid input
        
    #Re-enter this loop
    echo "Invalid input..."
    ;;
    esac
    done
done
