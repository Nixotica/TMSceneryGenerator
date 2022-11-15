import requests

MAP_ID = 1
MAP_REQUEST = requests.get(url="https://trackmania.exchange/maps/download/{id}".format(MAP_ID))

# Map_File = open("MAP_REQUEST.txt", "x")
print (MAP_REQUEST)



# with open ('MAP_REQUEST') as Map_File: 
# do stuff