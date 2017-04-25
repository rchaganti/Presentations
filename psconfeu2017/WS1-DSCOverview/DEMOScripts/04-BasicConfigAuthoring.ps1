Configuration ArchiveDemo {
    Node localhost {
        Archive ArchiveDemo {
            Path = "C:\demoscripts\Scripts.zip"
            Destination = "C:\Scripts"
            Ensure="Present"
        }
    }
}

#Compile the configuration to a MOF
#Without -OutputPath, a folder with configuration name gets created in the current working directory
#When compiling you will see a warning message about importing PSDesiredStateConfiguration module
ArchiveDemo -OutputPath C:\DemoScripts\Archivedemo

#Open the compiled MOF and understand the contents
psEdit C:\DemoScripts\Archivedemo\localhost.mof

#using node keyword is not mandatory
#The following configuration will also compile into localhost.mof
Configuration ArchiveDemo {
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    Archive ArchiveDemo {
        Path = "C:\demoscripts\Scripts.zip"
        Destination = "C:\Scripts"
        Ensure="Present"
    }
}

#Specifying remote node names
Configuration ArchiveDemo {
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    Node @('S16-01','S16-02') {
        Archive ArchiveDemo {
            Path = "C:\demoscripts\Scripts.zip"
            Destination = "C:\Scripts"
            Ensure="Present"
        }
    }
}


