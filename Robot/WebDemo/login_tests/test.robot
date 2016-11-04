*** Settings ***





Suite Teardown    Close Browser


Resource          resource.robot

*** Variables ***
${CREDENTIALS}  key:secret
${SITE}			http://www.google.com

*** Keywords ***
Browser is opened to login page
    Open Browser    ${SITE}    ${BROWSER}

*** Test Cases ***

Simple Test
    Browser is opened to login page
    Page should contain  Google
    [Teardown]    Close Browser


