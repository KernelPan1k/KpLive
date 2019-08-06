#!/bin/sh

clear
if [ "$1" == "-acf" ]
then
  while true
  do
    echo "Type the name of the file to find or type exit to quit:"
    read ff
    clear
    if [ "$ff" == "exit" ]
    then
      break
    else
      if [ -e filefind.txt ]
      then
        echo >>filefind.txt
      fi
    fi
    echo "Searching for $ff.... please wait"
    echo "Search results for $ff" >>filefind.txt
    echo >>filefind.txt
    find /mnt|grep -ie /$ff$ |sed 's/.*pebuilder.*//g' |while read line
    do
      md5sum "$line" >>filefind.txt
      ls -lh "$line" |sed -e 's/.*root //g;s/\/mnt.*//g'>>filefind.txt
      echo >>filefind.txt
      echo "$line"
    done
    cabextract --h &> /dev/null
    if [ $? == 1 ]
    then
      find /mnt|grep -ie /*.cab$ |grep -ie i386 |sed 's/.*pebuilder.*//g' >cl.txt
      if [ $? == 1 ]
      then
        echo "did not find cab files to include">>filefind.txt
      else
        while read cline
        do
          cabextract -l -F $ff "$cline" |sed 's/All done.*//g' >>filefind.txt
        done <cl.txt
      fi
    else
      echo "cab files not included in search .... cabextract not installed">>filefind.txt
    fi
    if [ -e cl.txt ]
    then
      rm cl.txt
    fi
    echo
    echo "Done"
    echo
    continue
  done
else
  if [ "$1" == "-cf" ]
  then
    echo "Type the name of the file to find:"
    read ff
    clear
    echo "Searching for $ff.... please wait"
    echo "Search results for $ff" >filefind.txt
    echo >>filefind.txt
    find /mnt|grep -ie /$ff$ |sed 's/.*pebuilder.*//g' |while read line
    do
      md5sum "$line" >>filefind.txt
      ls -lh "$line" |sed -e 's/.*root //g;s/\/mnt.*//g'>>filefind.txt
      echo >>filefind.txt
      echo "$line"
    done
    cabextract --h &> /dev/null
    if [ $? == 1 ]
    then
      find /mnt|grep -ie /*.cab$ |grep -ie i386 |sed 's/.*pebuilder.*//g'  >cl.txt
      if [ $? == 1 ]
      then
        echo "did not find cab files to include">>filefind.txt
      else
        while read cline
        do
          cabextract -l -F $ff "$cline" |sed 's/All done.*//g' >>filefind.txt
        done <cl.txt
      fi
    else
      echo "cab files not included in search .... cabextract not installed">>filefind.txt
    fi
    if [ -e cl.txt ]
    then
      rm cl.txt
    fi
    echo
    echo "Done"
  else
    if [ "$1" == "-af" ]
    then
      while true
      do
        echo "Type the name of the file to find or type exit to quit:"
        read ff
        clear
        if [ "$ff" == "exit" ]
        then
          break
        else
          if [ -e filefind.txt ]
          then
            echo >>filefind.txt
          fi
        fi
        echo "Searching for $ff.... please wait"
        echo "Search results for $ff" >>filefind.txt
        echo >>filefind.txt
        find /mnt|grep -ie /$ff$ |sed 's/.*pebuilder.*//g' |while read line
        do
          md5sum "$line" >>filefind.txt
          ls -lh "$line" |sed -e 's/.*root //g;s/\/mnt.*//g'>>filefind.txt
          echo >>filefind.txt
          echo "$line"
        done
        echo
        echo "Done"
        echo
        continue
      done
    else
      if [ "$1" == "-f" ]
      then
        echo "Type the name of the file to find:"
        read ff
        clear
        echo "Searching for $ff.... please wait"
        echo "Search results for $ff" >filefind.txt
        echo >>filefind.txt
        find /mnt|grep -ie /$ff$ |sed 's/.*pebuilder.*//g' |while read line
        do
          md5sum "$line" >>filefind.txt
          ls -lh "$line" |sed -e 's/.*root //g;s/\/mnt.*//g'>>filefind.txt
          echo >>filefind.txt
          echo "$line"
        done
        echo
        echo "Done"
      else
        if [ "$1" == "-r" ]
        then
          if [ -e replace.txt ]
          then
            echo "clear" >filerep.sh
            echo "echo \"Beginning replacement procedure\"" >>filerep.sh
            echo "Beginning replacement procedure" >filerep.txt
            echo >>filerep.txt
            IFS="::"
            while read e1 e2 e3 e4
            do
              if [ "$e1" != "\r" ]
              then
                if [ "$e3" != "" ]
                then
                  target=$e1
                  source=$e3
                  if [ -e "$target" ]
                  then
                    if [ -e "$source" ]
                    then
                      if [ -e "$target".orig ]
                      then
                        echo "mv \""${target//\$/\\\$}"\" \""${target//\$/\\\$}".ntb\"" >>filerep.sh
                        echo "cp \""${source//\$/\\\$}"\" \""${target//\$/\\\$}"\"" >>filerep.sh
                        echo "mv \""$target"\" \""$target".ntb\"" >>filerep.txt
                        echo "cp \""$source"\" \""$target"\"" >>filerep.txt
                      else
                        echo "mv \""${target//\$/\\\$}"\" \""${target//\$/\\\$}".orig\"" >>filerep.sh
                        echo "cp \""${source//\$/\\\$}"\" \""${target//\$/\\\$}"\"" >>filerep.sh
                        echo "mv \""$target"\" \""$target".orig\"" >>filerep.txt
                        echo "cp \""$source"\" \""$target"\"" >>filerep.txt
                      fi
                    else
                      echo "Source file $source not present!" >>filerep.txt
                      echo "Source file $source not present!"
                      exit
                    fi
                  else
                    echo "Target file $target not present!" >>filerep.txt
                    echo "Target file $target not present!"
                    exit
                  fi
                fi
              fi
            done <replace.txt
            unset IFS
            echo "echo \"Done!\"" >>filerep.sh
            echo "rm -f \$0" >>filerep.sh
            bash filerep.sh
          else
            echo "replace.txt missing"
            exit
          fi
        else
          echo $(date)>report.txt
          echo "Gathering driver information .... please be patient"
          echo "This will take several minutes to complete"
          echo >>log.txt
          find /mnt|grep -ie /system32/drivers$ |sed 's/.*pebuilder.*//g;s/.*minint.*//g;s/.*Minint.*//g;s/.*MININT.*//g' | sed '/^$/d' >driv.txt
          while read e1
          do
            echo "Driver report for $e1" >log.txt
            find "$e1"|sort -f|grep -ie .sys$ >files.txt
            while read e1
            do
              md5sum "$e1"|sed -e 's/\/mnt.*\/drivers\///g;s/\/mnt.*\/DRIVERS\///g' >>drivers.txt
              od -c "$e1"|sed 's/\\0/\\\\/g'|sed -e :a -e '/\\$/N;s/\\\n//; ta'|sed -e 's/\\//g' \
              -e 's/[0-9]//g;s/ //g'|grep CompanyName|sed -e 's/.*CompanyNameMicrosoftCorp\..*/CompanyName Microsoft Corp/g' \
              -e 's/.*CompanyNameMicrosoftCorporation.*/CompanyName Microsoft Corporation/g' \
              -e 's/.*CompanyNameAcerLaboratories.*/CompanyName Acer Laboratories/g' \
              -e 's/.*CompanyNameAcronis.*/CompanyName Acronis/g' \
              -e 's/.*CompanyNameAdaptec.*/CompanyName Adaptec/g' \
              -e 's/.*CompanyNameADMtekIncorporated.*/CompanyName ADMtek Incorporated/g' \
              -e 's/.*CompanyNameAdvancedMicroDevices.*/CompanyName Advanced Micro Devices/g' \
              -e 's/.*CompanyNameAdvancedSystemProducts.*/CompanyName Advanced System Products/g' \
              -e 's/.*CompanyNameAgereSystems.*/CompanyName Agere Systems/g' \
              -e 's/.*CompanyNameAgilentTechnologies.*/CompanyName Agilent Technologies/g' \
              -e 's/.*CompanyNameAheadSoftware.*/CompanyName Ahead Software/g' \
              -e 's/.*CompanyNameAlcorMicroCorp.*/CompanyName Alcor Micro Corp/g' \
              -e 's/.*CompanyNameALinxCorporation.*/CompanyName ALinx Corporation/g' \
              -e 's/.*CompanyNameAlpsElectricCo.*/CompanyName Alps Electric/g' \
              -e 's/.*CompanyNameALWILSoftware.*/CompanyName ALWIL Software/g' \
              -e 's/.*CompanyNameAmbiCom.*/CompanyName Ambi Com/g' \
              -e 's/.*CompanyNameAMC.*/CompanyName AMC/g' \
              -e 's/.*CompanyNameAMDInc.*/CompanyName AMD Inc/g' \
              -e 's/.*CompanyNameAMDTechnologies.*/CompanyName AMD Technologies/g' \
              -e 's/.*CompanyNameAmericanMegatrendsInc.*/CompanyName American Megatrends/g' \
              -e 's/.*CompanyNameAmericaOnline.*/CompanyName America Online/g' \
              -e 's/.*CompanyNameAnalogDevices.*/CompanyName Analog Devices/g' \
              -e 's/.*CompanyNameAndreaElectronicsCorporation.*/CompanyName Andrea Electronics Corporation/g' \
              -e 's/.*CompanyNameApple.*/CompanyName Apple/g' \
              -e 's/.*CompanyNameArcsoft.*/CompanyName Arcsoft/g' \
              -e 's/.*CompanyNameASIXElectronics.*/CompanyName ASIX Electronics/g' \
              -e 's/.*CompanyNameAtherosCommunications.*/CompanyName Atheros Communications/g' \
              -e 's/.*CompanyNameATIResearch.*/CompanyName ATI/g' \
              -e 's/.*CompanyNameATITechnologiesInc.*/CompanyName ATI Technologies/g' \
              -e 's/.*CompanyNameATTOTechnology.*/CompanyName ATTO Technology/g' \
              -e 's/.*CompanyNameAVGTechnologies.*/CompanyName AVG Technologies/g' \
              -e 's/.*CompanyNameAviraGmb.*/CompanyName Avira Gmb/g' \
              -e 's/.*CompanyNameAVMGmbH.*/CompanyName AVM GmbH/g' \
              -e 's/.*CompanyNameBayNetworks.*/CompanyName Bay Networks/g' \
              -e 's/.*CompanyNameBelkinCorporation.*/CompanyName Belkin Corporation/g' \
              -e 's/.*CompanyNameBreezeCOM.*/CompanyName Breeze COM/g' \
              -e 's/.*CompanyNameBroadcomCorporation.*/CompanyName Broadcom Corporation/g' \
              -e 's/.*CompanyNameBrotherIndustries.*/CompanyName Brother Industries/g' \
              -e 's/.*CompanyNameCARDBUS.*/CompanyName CARDBUS/g' \
              -e 's/.*CompanyNameCATC.*/CompanyName Computer Access Technology/g' \
              -e 's/.*CompanyNameChic.*/CompanyName Chic Corp/g' \
              -e 's/.*CompanyNameCisco-Linksys.*/CompanyName Cisco-Linksys/g' \
              -e 's/.*CompanyNameCiscoSystems.*/CompanyName Cisco Systems/g' \
              -e 's/.*CompanyNameCMDTechnology.*/CompanyName CMD Technology/g' \
              -e 's/.*CompanyNameC-Media.*/CompanyName C-Media/g' \
              -e 's/.*CompanyNameCNetTechnology.*/CompanyName CNet Technology/g' \
              -e 's/.*CompanyNameComCorporation.*/CompanyName Com Corporation/g' \
              -e 's/.*CompanyNameCompaqComputerCorp.*/CompanyName Compaq Computer Corp/g' \
              -e 's/.*CompanyNameCompaqComputerCorporation.*/CompanyName Compaq Computer Corporation/g' \
              -e 's/.*CompanyNameComtrolCorporation.*/CompanyName Comtrol Corporation/g' \
              -e 's/.*CompanyNameConceptronicCorporation.*/CompanyName Conceptronic Corporation/g' \
              -e 's/.*CompanyNameConexant.*/CompanyName Conexant/g' \
              -e 's/.*CompanyNameConexantSystems.*/CompanyName Conexant Systems/g' \
              -e 's/.*CompanyNameCopyright(C)CreativeTechnology.*/CompanyName Creative Technology/g' \
              -e 's/.*CompanyNamecorega.*/CompanyName CoreGA/g' \
              -e 's/.*CompanyNameCreativeTechnology.*/CompanyName Creative Technology/g' \
              -e 's/.*CompanyNameDAVICOMSemiconductor.*/CompanyName DAVICOM Semiconductor/g' \
              -e 's/.*CompanyNameDellComputerCorporation.*/CompanyName Dell Computer Corporation/g' \
              -e 's/.*CompanyNameDellInc.*/CompanyName Dell/g' \
              -e 's/.*CompanyNameDeonvanderWesthuysen.*/CompanyName Deonvander Westhuysen/g' \
              -e 's/.*CompanyNameDigiInternational.*/CompanyName Digi International/g' \
              -e 's/.*CompanyNameDigitalNetworks.*/CompanyName Digital Networks/g' \
              -e 's/.*CompanyNameD-Link.*/CompanyName D-Link/g' \
              -e 's/.*CompanyNameDuplexSecure.*/CompanyName Duplex Secure/g' \
              -e 's/.*CompanyNameEiconNetworks.*/CompanyName Eicon Networks/g' \
              -e 's/.*CompanyNameEiconTechnology.*/CompanyName Eicon Technology/g' \
              -e 's/.*CompanyNameELANTECHDevicesCorp.*/CompanyName ELANTECH Devices/g' \
              -e 's/.*CompanyNameEmulex.*/CompanyName Emulex/g' \
              -e 's/.*CompanyNameEquinoxSystems.*/CompanyName Equinox Systems/g' \
              -e 's/.*CompanyNameeSageLab.*/CompanyName eSage Lab/g' \
              -e 's/.*CompanyNameFastEthernetControllerProvider.*/CompanyName Fast Ethernet Controller Provider/g' \
              -e 's/.*CompanyNameFORESystems.*/CompanyName FORE Systems/g' \
              -e 's/.*CompanyNameFreeBT.*/CompanyName FreeBT/g' \
              -e 's/.*CompanyNameFUJITSULIMITED.*/CompanyName FUJITSU LIMITED/g' \
              -e 's/.*CompanyNameGARMINCorp.*/CompanyName GARMIN Corp/g' \
              -e 's/.*CompanyNameGEARSoftware.*/CompanyName GEAR Software/g' \
              -e 's/.*CompanyNameGMER.*/CompanyName GMER/g' \
              -e 's/.*CompanyNameHauppaugeComputerWorks.*/CompanyName Hauppauge Computer Works/g' \
              -e 's/.*CompanyNameHewlett-PackardCompany.*/CompanyName Hewlett-Packard/g' \
              -e 's/.*CompanyNameHewlett-PackardDevelopmentCompany.*/CompanyName Hewlett-Packard/g' \
              -e 's/.*CompanyNameHighPointTechnologies.*/CompanyName HighPoint Technologies/g' \
              -e 's/.*CompanyNameHiTRUST.*/CompanyName HiTrust/g' \
              -e 's/.*CompanyNameHP.*/CompanyName HP/g' \
              -e 's/.*CompanyNameIBMCorp.*/CompanyName IBM Corp/g' \
              -e 's/.*CompanyNameIBMCorporation.*/CompanyName IBM Corporation/g' \
              -e 's/.*CompanyNameICPvortex.*/CompanyName ICP Vortex/g' \
              -e 's/.*CompanyNameInprocomm.*/CompanyName Inprocomm/g' \
              -e 's/.*CompanyNameIntegratedTechnologyExpress.*/CompanyName Integrated Technology Express/g' \
              -e 's/.*CompanyNameIntel(R)Corporation.*/CompanyName Intel Corporation/g' \
              -e 's/.*CompanyNameIntelCorp\..*/CompanyName Intel Corp/g' \
              -e 's/.*CompanyNameIntelCorporation.*/CompanyName Intel Corporation/g' \
              -e 's/.*CompanyNameInterphase(R)Corporation.*/CompanyName Interphase Corporation/g' \
              -e 's/.*CompanyNameIntersilAmericas.*/CompanyName Intersil Americas/g' \
              -e 's/.*CompanyNameInterVideo.*/CompanyName InterVideo/g' \
              -e 's/.*CompanyNameJetico.*/CompanyName Jetico/g' \
              -e 's/.*CompanyNameKasperskyLab.*/CompanyName Kaspersky Lab/g' \
              -e 's/.*CompanyNameKingstonTechnology.*/CompanyName Kingston Technology/g' \
              -e 's/.*CompanyNameKLSIUSA.*/CompanyName KLSI USA/g' \
              -e 's/.*CompanyNameLavasoft.*/CompanyName Lavasoft/g' \
              -e 's/.*CompanyNameLenovo.*/CompanyName Lenovo/g' \
              -e 's/.*CompanyNameLinksys.*/CompanyName Linksys/g' \
              -e 's/.*CompanyNameLinkSysGroup.*/CompanyName Linksys/g' \
              -e 's/.*CompanyNameLinksysGroup.*/CompanyName Linksys/g' \
              -e 's/.*CompanyNameLogitech.*/CompanyName Logitech/g' \
              -e 's/.*CompanyNameLSICorporation.*/CompanyName LSI Corporation/g' \
              -e 's/.*CompanyNameLSILogic.*/CompanyName LSI Logic/g' \
              -e 's/.*CompanyNameLT.*/CompanyName LT/g' \
              -e 's/.*CompanyNameLucentTechnologies.*/CompanyName Lucent Technologies/g' \
              -e 's/.*CompanyNameMacronixInternational.*/CompanyName Macronix International/g' \
              -e 's/.*CompanyNameMacrovisionCorporation.*/CompanyName Macrovision Corporation/g' \
              -e 's/.*CompanyNameMadgeNetworks.*/CompanyName Madge Networks/g' \
              -e 's/.*CompanyNameMalwarebytesCorporation.*/CompanyName Malwarebytes Corporation/g' \
              -e 's/.*CompanyNameMarconiCommunications.*/CompanyName Marconi Communications/g' \
              -e 's/.*CompanyNameMarvell.*/CompanyName Marvell/g' \
              -e 's/.*CompanyNameMatroxGraphicsInc.*/CompanyName Matrox Graphics/g' \
              -e 's/.*CompanyNameMcAfee.*/CompanyName McAfee/g' \
              -e 's/.*CompanyNameMCCI.*/CompanyName MCCI SAMSUNG/g' \
              -e 's/.*CompanyNameMeetinghouseDataCommunications.*/CompanyName Meetinghouse Data Communications/g' \
              -e 's/.*CompanyNameMELCO.*/CompanyName MELCO/g' \
              -e 's/.*CompanyNameMotorola.*/CompanyName Motorola/g' \
              -e 's/.*CompanyNameM-Systems.*/CompanyName M-Systems/g' \
              -e 's/.*CompanyNameMusicMatch.*/CompanyName MusicMatch/g' \
              -e 's/.*CompanyNameMylexCorporation.*/CompanyName Mylex Corporation/g' \
              -e 's/.*CompanyNameNationalSemiconductor.*/CompanyName National Semiconductor/g' \
              -e 's/.*CompanyNameNETGEAR.*/CompanyName NETGEAR/g' \
              -e 's/.*CompanyNameNewTechInfosystems.*/CompanyName NewTech Infosystems/g' \
              -e 's/.*CompanyNameN-trigInnovativeTechnologies.*/CompanyName N-trig Innovative Technologies/g' \
              -e 's/.*CompanyNameNVIDIACorporation.*/CompanyName NVIDIA Corporation/g' \
              -e 's/.*CompanyNameOsitechCommunications.*/CompanyName Ositech Communications/g' \
              -e 's/.*CompanyNamePadus.*/CompanyName Padus/g' \
              -e 's/.*CompanyNamePandaSecurity.*/CompanyName Panda Security/g' \
              -e 's/.*CompanyNameParallelTechnologies.*/ CompanyName Parallel Technologies/g' \
              -e 's/.*CompanyNamePCTools.*/CompanyName PC Tools/g' \
              -e 's/.*CompanyNamePerleSystems.*/CompanyName Perle Systems/g' \
              -e 's/.*CompanyNamePinnacleadivisionofAvidTechnology.*/CompanyName Pinnacle Systems/g' \
              -e 's/.*CompanyNamePinnacleSystems.*/CompanyName Pinnacle Systems/g' \
              -e 's/.*CompanyNamePowerQuestCorporation.*/CompanyName PowerQuest Corporation/g' \
              -e 's/.*CompanyNamePromiseTechnology.*/CompanyName Promise Technology/g' \
              -e 's/.*CompanyNameQLogicCorporation.*/CompanyName QLogic Corporation/g' \
              -e 's/.*CompanyNameQSoft.*/CompanyName QSoft/g' \
              -e 's/.*CompanyNameRadioLAN.*/CompanyName Radio LAN/g' \
              -e 's/.*CompanyNameRalinkTechnology.*/CompanyName Ralink Technology/g' \
              -e 's/.*CompanyNameRapidSolutionSoftware.*/CompanyName Rapid Solution Software/g' \
              -e 's/.*CompanyNameRAVISENTTechnologiesInc\..*/CompanyName Ravisent Technologies/g' \
              -e 's/.*CompanyNameRaxcoSoftware.*/CompanyName Raxco Software/g' \
              -e 's/.*CompanyNameRaytheonCorp.*/CompanyName RaytheonCorp/g' \
              -e 's/.*CompanyNameRazer(Asia-Pacific)Pte.*/CompanyName Razer \(Asia-Pacific\) Pte/g' \
              -e 's/.*CompanyNameRealtekCorporation.*/CompanyName Realtek Corporation/g' \
              -e 's/.*CompanyNameRealtekSemiconductor.*/CompanyName Realtek Semiconductor/g' \
              -e 's/.*CompanyNameREDC.*/CompanyName Ricoh Company/g' \
              -e 's/.*CompanyNameResearchinMotionLtd.*/CompanyName Research in Motion/g' \
              -e 's/.*CompanyNameRicoh.*/CompanyName Ricoh/g' \
              -e 's/.*CompanyNameRIF.*/CompanyName RIF/g' \
              -e 's/.*CompanyNameRoxio.*/CompanyName Roxio/g' \
              -e 's/.*CompanyNameS\/DiamondMultimediaSystems.*/CompanyName Diamond Multimedia Systems/g' \
              -e 's/.*CompanyNameSCMMicrosystems.*/CompanyName SCM Microsystems/g' \
              -e 's/.*CompanyNameSensaura.*/CompanyName Sensaura/g' \
              -e 's/.*CompanyNameService\&QualityTechnology.*/CompanyName Service \& Quality Technology/g' \
              -e 's/.*CompanyNameSGraphics.*/CompanyName SGraphics/g' \
              -e 's/.*CompanyNameSierraWireless.*/CompanyName Sierra Wireless/g' \
              -e 's/.*CompanyNameSigmaTel.*/CompanyName SigmaTel/g' \
              -e 's/.*CompanyNameSilicomLtd.*/CompanyName Silicom Ltd/g' \
              -e 's/.*CompanyNameSiliconImage.*/CompanyName Silicon Image/g' \
              -e 's/.*CompanyNameSiliconIntegratedSystems.*/CompanyName Silicon Integrated Systems/g' \
              -e 's/.*CompanyNameSiSCorporation.*/CompanyName SiS Corporation/g' \
              -e 's/.*CompanyNameSmartLink.*/CompanyName Smart Link/g' \
              -e 's/.*CompanyNameSMC.*/CompanyName SMC/g' \
              -e 's/.*CompanyNameSMSC.*/CompanyName SMSC/g' \
              -e 's/.*CompanyNameSonicSolutions.*/CompanyName Sonic Solutions/g' \
              -e 's/.*CompanyNameSonyCorporation.*/CompanyName Sony Corporation/g' \
              -e 's/.*CompanyNameStallionTechnologies.*/CompanyName Stallion Technologies/g' \
              -e 's/.*CompanyNameStorageCraftTechnologyCorporation.*/CompanyName Storage Craft Technology/g' \
              -e 's/.*CompanyNameSymantecCorporation.*/CompanyName Symantec Corporation/g' \
              -e 's/.*CompanyNameSymbiosLogicInc.*/CompanyName Symbios Logic/g' \
              -e 's/.*CompanyNameSymbolTechnologies.*/CompanyName Symbol Technologies/g' \
              -e 's/.*CompanyNameSynaptics.*/CompanyName Synaptics/g' \
              -e 's/.*CompanyNameSysKonnect.*/CompanyName Sys Konnect/g' \
              -e 's/.*CompanyNameTDKCorporation.*/CompanyName TDK Corporation/g' \
              -e 's/.*CompanyNameTexasInstruments.*/CompanyName Texas Instruments/g' \
              -e 's/.*CompanyNameTheLinksysGroup.*/CompanyName Linksys/g' \
              -e 's/.*CompanyNameThesyconGmbH.*/CompanyName Thesycon GmbH/g' \
              -e 's/.*CompanyNameTigerJetNetwork.*/CompanyName TigerJet Network/g' \
              -e 's/.*CompanyNameToshibaCorp.*/CompanyName Toshiba Corporation/g' \
              -e 's/.*CompanyNameTOSHIBACorporation.*/CompanyName Toshiba Corporation/g' \
              -e 's/.*CompanyNameToshibaCorporation.*/CompanyName Toshiba Corporation/g' \
              -e 's/.*CompanyNameTriplePoint.*/CompanyName Triple Point/g' \
              -e 's/.*CompanyNameUleadSystems.*/CompanyName Ulead Systems/g' \
              -e 's/.*CompanyNameULiElectronics.*/CompanyName ULi Electronics/g' \
              -e 's/.*CompanyNameUSBLANProvider.*/CompanyName USB LAN Provider/g' \
              -e 's/.*CompanyNameUSRoboticsMCD.*/CompanyName US Robotics MCD/g' \
              -e 's/.*CompanyNameVERITASSoftware.*/CompanyName VERITAS Software/g' \
              -e 's/.*CompanyNameVIATechnologies.*/CompanyName VIA Technologies/g' \
              -e 's/.*CompanyNameVMware.*/CompanyName VMware/g' \
              -e 's/.*CompanyNameVSOSoftware.*/CompanyName VSO Software/g' \
              -e 's/.*CompanyNameWacomTechnology.*/CompanyName Wacom Technology/g' \
              -e 's/.*CompanyNameware.*/CompanyName Ware/g' \
              -e 's/.*CompanyNameWinbondElectronicsCorporation.*/CompanyName Winbond Electronics/g' \
              -e 's/.*CompanyNameXIMETA.*/CompanyName XIMETA/g' \
              -e 's/.*CompanyNameXircom.*/CompanyName Xircom/g' \
              -e 's/.*ProductNameCom-CRWEAWirelessLANPCCard.*/CompanyName Com USA/g' \
              -e 's/.*InternalNameNetWlan\.sys.*/CompanyName 802\.11b/g' \
              -e 's/.*ProductNameLinksysLnetxFastEthernetAdapter.*/CompanyName Linksys/g' \
              -e 's/.*CompanyNameWindows(R)DDKprovider.*/CompanyName Windows DDK provider/g' \
              -e 's/.*CompanyNameWindows(R)ServerDDKprovider.*/CompanyName Windows Server DDK provider/g'|grep CompanyName|sed 's/CompanyName //g' >>drivers.txt
              echo >>drivers.txt
              echo "$e1 Processed"
            done <files.txt
            clear
            echo "Parsing results .... please wait"
            for fline in `sed -n '/.*\.sys$/p' drivers.txt`
            do
              if [ "`sed -n -e '/'"$fline"'/ {n; p;}' drivers.txt`" == "" ]
              then
                echo "$fline" >>log.txt
              fi
            done
            sed 's/\(.*\.sys\)/\\\1/g' log.txt|sed -e :a -e '$!N;s/\n\\\(.*\)/ \1 has NO Company Name!/;ta' -e 'P;D' >>log1.txt
            echo >>log1.txt
            clear
            echo "`sed -n '/.*NO Company Name!/p' log1.txt`"
            cat log1.txt drivers.txt >>report.txt
            rm log.txt
            rm log1.txt
            rm drivers.txt
          done <driv.txt
          rm driv.txt
          rm files.txt
          echo
          echo "Done"
        fi
      fi
    fi
  fi
fi

