
#script to parse block name with id from log
f = open("blockData.txt", "x")
with open("C:/Users/daveb/OpenplanetNext/Plugins/TMSceneryGenerator/TMSceneryGenerator/Plugin/src/scripts/Openplanet.log", "r") as file:
        for line in file:
            if "[TMSceneryGenerator]" in line and "ScriptRuntime" in line:
                line = line.split(" ")
                f.write(str(line[7] +" " +line[8]))