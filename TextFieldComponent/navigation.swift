We are working on Phase 5: Change Password Analytics and have a few queries regarding the Biometrics flow.

Current workflow:

Change password API success → Save biometrics secret → Trigger biometrics flow → Return success/failure

Since the biometrics flow is triggered by the system UI (on both iOS and Android), we have limited control over this part of the flow. Given that, we’re unsure where to place the analytics call for:
state_change-password_biometric-details

Additionally, we have the following events defined:

state_change-password_biometric-confirmation

state_change-password_biometric-fail

These are meant to represent the success and failure outcomes of the biometric step.

Our questions:

Should state_change-password_biometric-confirmation and state_change-password_biometric-fail be considered state events or should they be tracked as user actions?

Where should we ideally place the call for state_change-password_biometric-details, given that the biometric prompt is handled by the system and not under our direct control?


                                                                                                                                                                                                        git config --global user.name
                                                                                                                                                                                                        git config --global user.email
                                                                                                                                                                                                        git config user.name
                                                                                                                                                                                                        git config user.email
                                                                                                                                                                                                        git config --global user.name "Your Name"
                                                                                                                                                                                                        git config --global user.email "your.email@example.com"
                                                                                                                                                                                                        
                                                                                                                                                                                                        git config user.name "Your Name"
                                                                                                                                                                                                        git config user.email "your.email@example.com"

