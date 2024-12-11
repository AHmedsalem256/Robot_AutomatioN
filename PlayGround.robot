*** Settings ***
Documentation  This is an automation script for a Website Playground to order a pizza

Library    SeleniumLibrary


*** Variables ***

${URL}    https://dineshvelhal.github.io/testautomation-playground/login.html
${DEV_NAME}    Edge


${Passwrod}    admin
${Username}    admin

${Passwrod_Invalid}    5639
${Username_Invalid}    Ahmed

${Username_Field}    xpath=//input[@id="user"]
${Password_Field}    xpath=//input[@id="password"]

${Login_Button}    xpath=//button[@type="submit"]


@{Group_Element}    ${Password_Field}    ${Username_Field}    ${Login_Button}


${OpenMessage}    css:h3
${Error_Message}    xpath=//span[@id="message"]

${Pizza_Size_Large}    xpath=//input[@id="rad_large"]
${Pizza_Size_Medium}    xpath=//input[@id="rad_medium"]
${Pizza_Size_Small}    xpath=//input[@id="rad_small"]

${Selection_Favour}    xpath=//select[@id="select_flavor"]
${Selection_Favour_Cheese}    xpath=//select[@id="select_flavor"]


${Select_Numbers_Of_Pizza}    xpath=//input[@id="quantity"]

${SQL_Injection}    ' OR 1=1 --


${Quantity_Field}    xpath=//input[@type="number"]



*** Keywords ***
Open_Website_Login
    Open Browser    ${URL}    ${DEV_NAME}
    Wait Until Page Contains Element    ${Username_Field}    timeout=5
    Input Text    ${Password_Field}    ${Passwrod}
    Input Text    ${Username_Field}    ${Username}
    Click Element    ${Login_Button}

Open_Website_Login_Invalid_Password
    Open Browser    ${URL}    ${DEV_NAME}
    Wait Until Page Contains Element    ${Username_Field}    timeout=5
    Input Text    ${Password_Field}    ${Passwrod_Invalid}
    Input Text    ${Username_Field}    ${Username}
    Click Element    ${Login_Button}


Open_Website_Login_Invalid_Username
    Open Browser    ${URL}    ${DEV_NAME}
    Wait Until Page Contains Element    ${Username_Field}    timeout=5
    Input Text    ${Password_Field}    ${Passwrod}
    Input Text    ${Username_Field}    ${Username_Invalid}
    Click Element    ${Login_Button}
Open_Website_Login_Invalid_CasesSensitive
    Open Browser    ${URL}    ${DEV_NAME}
    Wait Until Page Contains Element    ${Username_Field}    timeout=5
    Input Text    ${Password_Field}    Admin
    Input Text    ${Username_Field}    Admin
    Click Element    ${Login_Button}



*** Test Cases ***

#Test the Openning of the page sucessfully 

TC_F0_OpenSuccessfully
    [Documentation]    This is a test case to testing the openning of the login page
    Open Browser    ${URL}    ${DEV_NAME}
    Sleep    3
    FOR  ${i}  IN  @{Group_Element}
        Page Should Contain Element    ${i}
    END
    Close Browser


#testing the login Functionalty
TC_F1_LoginSuccessFully
    [Documentation]    This is a test case to test successful login of website
    Set Test Message    ThisISTestCase
    Open_Website_Login
    Wait Until Element Is Visible    ${OpenMessage}
    Close Browser

TC_F2_Login_Invalid_Passwrod
    [Documentation]    Testing the inputs with Invalid_Password
    Open_Website_Login_Invalid_Password
    Wait Until Element Is Visible    ${Error_Message}
    Sleep    1
    Close Browser



TC_F3_Login_Invalid_Username
    [Documentation]    Testing the inputs with Invalid_Username
    Open_Website_Login_Invalid_Username
    Wait Until Element Is Visible    ${Error_Message}
    Sleep    1
    Close Browser


TC_F4_Login_SenstiveCase
    [Documentation]    Testing the inputs with Cases senstive Admin not admin 
    Open_Website_Login_Invalid_CasesSensitive
    Wait Until Element Is Visible    ${Error_Message}
    Sleep    1
    Close Browser


TC_F5_CheckPasswrodMasking
    [Documentation]    Check That the input elements are masked 
    
    Open Browser    ${URL}    ${DEV_NAME}
    Maximize Browser Window

    Input Text    ${Password_Field}    secret123
    
    ${field_type}=     Get Element Attribute    ${Password_Field}    type
    Should Be Equal    ${field_type}    password    Password field should be masked

    Sleep    1
    Close Browser


TC_F6_SQLInjection
    [Documentation]    Testing the sql injection 
    Open Browser    ${URL}    ${DEV_NAME}
    Maximize Browser Window
    Input Text    ${Password_Field}    ${SQL_Injection}
    Input Text    ${Username_Field}    ${SQL_Injection}
    Click Button    ${Login_Button}
    Wait Until Page Contains    Invalid username or password    timeout=5    Ensure error message is displayed
    Page Should Not Contain     Welcome, admin!      Ensure unauthorized access is blocked
    Close Browser


TC_F7_Verify Multi-Tab Session Handling
    [Documentation]    test response when the onpenning multi-tab after login 
    Open_Website_Login
    Maximize Browser Window
    #Open Another Tab and open the link url 
    Execute Javascript    window.open("${URL}","_blank")
    #switch to another tab 
    Switch Window    title=login
    Close Browser


TC_F8_Perform_Full_order
    [Documentation]    Full Order Functionallity 
    Open_Website_Login
    Input Text    ${Quantity_Field}    12
    Click Button    xpath=//button[@type="submit"]
    Wait Until Element Is Visible    css:h2    timeout=10
    Close Browser


    
