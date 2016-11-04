.. code:: robotframework
*** Test Cases ***
User can create an account and log in
    Create Valid User    fred    P4ssw0rd
    Attempt to Login with Credentials    fred    P4ssw0rd
    Status Should Be    Logged In

*** Settings ***
Library           OperatingSystem
Library           lib/LoginLibrary.py

*** Keywords ***
Clear login database
    Remove file    ${DATABASE FILE}

Create valid user
    [Arguments]    ${username}    ${password}
    Create user    ${username}    ${password}
    Status should be    SUCCESS

Creating user with invalid password should fail
    [Arguments]    ${password}    ${error}
    Create user    example    ${password}
    Status should be    Creating user failed: ${error}

Login
    [Arguments]    ${username}    ${password}
    Attempt to login with credentials    ${username}    ${password}
    Status should be    Logged In

# Keywords below used by higher level tests. Notice how given/when/then/and
# prefixes can be dropped. And this is a comment.

A user has a valid account
    Create valid user    ${USERNAME}    ${PASSWORD}

She changes her password
    Change password    ${USERNAME}    ${PASSWORD}    ${NEW PASSWORD}
    Status should be    SUCCESS

She can log in with the new password
    Login    ${USERNAME}    ${NEW PASSWORD}

She cannot use the old password anymore
    Attempt to login with credentials    ${USERNAME}    ${PASSWORD}
    Status should be    Access Denied

*** Variables ***
${USERNAME}               janedoe
${PASSWORD}               J4n3D0e
${NEW PASSWORD}           e0D3n4J
${DATABASE FILE}          ${TEMPDIR}${/}robotframework-quickstart-db.txt
${PWD INVALID LENGTH}     Password must be 7-12 characters long
${PWD INVALID CONTENT}    Password must be a combination of lowercase and uppercase letters and numbers

*** Keywords ***
Database Should Contain
    [Arguments]    ${username}    ${password}    ${status}
    ${database} =     Get File    ${DATABASE FILE}
    Should Contain    ${database}    ${username}\t${password}\t${status}\n













 .. code:: python

    import os.path
    import subprocess
    import sys


    class LoginLibrary(object):

        def __init__(self):
            self._sut_path = os.path.join(os.path.dirname(__file__),
                                          '..', 'sut', 'login.py')
            self._status = ''

        def create_user(self, username, password):
            self._run_command('create', username, password)

        def change_password(self, username, old_pwd, new_pwd):
            self._run_command('change-password', username, old_pwd, new_pwd)

        def attempt_to_login_with_credentials(self, username, password):
            self._run_command('login', username, password)

        def status_should_be(self, expected_status):
            if expected_status != self._status:
                raise AssertionError("Expected status to be '%s' but was '%s'."
                                     % (expected_status, self._status))

        def _run_command(self, command, *args):
            command = [sys.executable, self._sut_path, command] + list(args)
            process = subprocess.Popen(command, stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT)
            self._status = process.communicate()[0].strip()
