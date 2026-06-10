const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "AdminQueries": {
                    "endpointType": "REST",
                    "endpoint": "https://ndqo4upfmg.execute-api.ap-south-1.amazonaws.com/ppvthree",
                    "region": "ap-south-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                },
                "personalproject": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://mm2kggjhxzbnfkq24ky2wszgyy.appsync-api.ap-south-1.amazonaws.com/graphql",
                    "region": "ap-south-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://mm2kggjhxzbnfkq24ky2wszgyy.appsync-api.ap-south-1.amazonaws.com/graphql",
                        "Region": "ap-south-1",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "personalproject_AMAZON_COGNITO_USER_POOLS"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "ap-south-1:5c6c55cc-df06-464f-9bf9-92ad87960ea6",
                            "Region": "ap-south-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-south-1_2wBHHU4mS",
                        "AppClientId": "3t5am65q1bvv2n1ttt0c1miqh6",
                        "Region": "ap-south-1"
                    }
                },
                "GoogleSignIn": {
                    "Permissions": "email,profile,openid",
                    "ClientId-WebApp": "813741887850-d9dko0p0je35r0n9lf8cc544jr5konuf.apps.googleusercontent.com"
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "personalproject258ebb3d-258ebb3d-ppvthree.auth.ap-south-1.amazoncognito.com",
                            "AppClientId": "3t5am65q1bvv2n1ttt0c1miqh6",
                            "SignInRedirectURI": "http://localhost:1234/",
                            "SignOutRedirectURI": "http://localhost:1234/logout/",
                            "Scopes": [
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "socialProviders": [
                            "GOOGLE"
                        ],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    }
}''';
