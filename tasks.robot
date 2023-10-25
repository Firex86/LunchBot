*** Settings ***
Documentation       Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.PDF
Library             RPA.Word.Application
Library             RPA.HTTP
Library             RPA.Robocorp.Vault
Library             RPA.Desktop
Library             RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library             RPA.Excel.Files
Library             RequestsLibrary
Library             RPA.JSON



*** Variables ***
# NOTE: User has to set the correct email and password.
${USERNAME}     <Correct Email>
${PASSWORD}     <Correct Password>
${LaureaRuoka}    Ruokalistan otsikko\n\n Ruoka1\n\n Ruoka2
${API_URL}        https://www.compass-group.fi
${Response}
${RestaurantName}
    




*** Tasks ***
Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.
    Fetch JSON Data
   

    
   

*** Keywords ***
Open the Browser For lunch menu, show whole week menu
    Open Available Browser
    ...    https://www.compass-group.fi/menuapi/feed/json?costNumber=3032&language=fi 
    
    
Fetch JSON Data
    RequestsLibrary.Create Session    mysession    ${API_URL}
    ${Response}=    RequestsLibrary.GET On Session    mysession    url=/menuapi/feed/json?costNumber=3032&language=fi 

    ${json_content}=    RequestsLibrary.to json    ${Response.content}

    # Word part added for testing purposes, which will be deleted in the final version
    RPA.Word.Application.Open Application
    Create New Document
    
    # Automation looks for each necessary part of the response
    ${Date0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].Date
    ${Salaatti0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[0].Name
    ${SalaattiRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[0].Components
    ${Kasvis0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[1].Name
    ${KasvisRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[1].Components
    ${Keitto0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[2].Name
    ${KeittoRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[2].Components
    ${Lounas0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[3].Name
    ${LounasRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[3].Components
    ${Jalki0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[4].Name
    ${JalkiRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[0].SetMenus[4].Components
    
    # Automation writes previous response part to word file
    Write Text    ${Date0}
    Write Text    ${Salaatti0}
    Write Text    ${SalaattiRuoka0}
    Write Text    ${Kasvis0}
    Write Text    ${KasvisRuoka0}
    Write Text    ${Keitto0}
    Write Text    ${KeittoRuoka0}
    Write Text    ${Lounas0}
    Write Text    ${LounasRuoka0}
    Write Text    ${Jalki0}
    Write Text    ${JalkiRuoka0}

    # Automation save the document as a word file and a .pdf file.
    Save Document As    RuokaL
    Export To Pdf    RuokaL
    Quit Application    save_changes=${True}
 

# Find allergies and color them
# Identify the allergy element, for example, by its XPath
# allergy_element = driver.find_element_by_xpath('//*[@id="app"]/main/div/div[3]/div/div/div/div[2]/div[2]/div[1]/div/div[1]/div/button/div[1]/div/p')

# Determine the condition that triggers color change
# if allergy_is_severe:
    # Use JavaScript to change the color (example: red)
    # driver.execute_script("arguments[0].style.backgroundColor = 'red';", allergy_element)
    
    # Define color mappings for each letter
# color_mappings = {
 #   'L': 'yellow',
  #  'M': 'black',
  #  'VL': 'yellow',
 #   'PÄ': 'red',
 #   'SO': 'red',
 #   'GL': 'black',
 #   'MU': 'red',
#}

Create A Word document and save it as a .pdf file
    #Note: this requires a Microsoft Word application on users computer to work correctly.
    RPA.Word.Application.Open Application
    Create New Document
    Write Text    ${LaureaRuoka}
    Save Document As    RuokaL
    Export To Pdf    RuokaL
    Quit Application    save_changes=${True}


Send An Email With The Correct Lunch Menu For One Person
    # Sends an email to a single recipient.
    [Arguments]    ${RECIPIENT}
    Authorize    account=${USERNAME}    password=${PASSWORD}
    Send Message    sender=${USERNAME}
    ...    recipients=${RECIPIENT}[Email]
    ...    subject=Ensiviikon ruokalista.
    ...    body=Ohessa ensiviikon ruokalista.
    ...    attachments=RuokaL.pdf

Send All Emails
    # Opens the premade Excel file and reads the contents.
    Open Workbook    Email_List.xlsx
    ${RECIPIENT}=    Read Worksheet As Table    header=${True}
    Close Workbook
    # Sends the email for each email account listed in the excel file.
    FOR    ${RECIPIENT}    IN    @{RECIPIENT}
        Send An Email With The Correct Lunch Menu For One Person    ${RECIPIENT}
    END

Open a new window and login to Google Drive
    Open Available Browser    https://drive.google.com/drive/u/1/folders/1f-stVk27w0S1YeMIhK9lBwWkEg6GnUHn
    Input Text    id:identifierId    ${USERNAME}
    Click Button    Next
    Wait Until Element Is Visible    name:Passwd
    Input Text    id:identifierId    ${PASSWORD}
    Click Button    Next