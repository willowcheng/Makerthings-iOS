//
//  OpenHABSettingsViewController.m
//  openHAB
//
//  Created by Victor Belov on 12/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "OpenHABSettingsViewController.h"
#import "OpenHABViewController.h"
#import "OpenHABDataObject.h"
#import <GAI.h>
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface OpenHABSettingsViewController ()

@end

@implementation OpenHABSettingsViewController
@synthesize localUrlTextField, remoteUrlTextField, usernameTextField, passwordTextField, ignoreSSLSwitch, demomodeSwitch, idleOffSwitch, settingsLocalUrl, settingsRemoteUrl, settingsUsername, settingsPassword, settingsIgnoreSSL, settingsDemomode, settingsIdleOff;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"OpenHABSettingsViewController viewDidLoad");
//    [self.navigationItem setHidesBackButton:TRUE];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [self loadSettings];
    [self updateSettingsUi];
    [localUrlTextField setDelegate:self];
    [remoteUrlTextField setDelegate:self];
    [usernameTextField setDelegate:self];
    [passwordTextField setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow
                                  animated:YES];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"OpenHABSettingsViewController"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


// This is to automatically hide keyboard on done/enter pressing
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)cancelButtonPressed:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Cancel button pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonPressed:(id)sender {
    // TODO: Make a check if any of the preferences has changed
    NSLog(@"Save button pressed");
    [self updateSettings];
    [self saveSettings];
    [[self appData] rootViewController].pageUrl = nil;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"OpenHABSettingsViewController prepareForSegue");
    if ([segue.identifier isEqualToString:@"showSelectSitemap"]) {
        NSLog(@"OpenHABSettingsViewController showSelectSitemap");
        [self updateSettings];
        [self saveSettings];
    }
}

- (void)updateSettingsUi
{
    localUrlTextField.text = settingsLocalUrl;
    remoteUrlTextField.text = settingsRemoteUrl;
    usernameTextField.text = settingsUsername;
    passwordTextField.text = settingsPassword;
    [ignoreSSLSwitch setOn:settingsIgnoreSSL];
    [demomodeSwitch setOn:settingsDemomode];
    [idleOffSwitch setOn:settingsIdleOff];
}

- (void)loadSettings
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    settingsLocalUrl = [prefs stringForKey:@"localUrl"];
    settingsRemoteUrl = [prefs stringForKey:@"remoteUrl"];
    settingsUsername = [prefs stringForKey:@"username"];
    settingsPassword = [prefs stringForKey:@"password"];
    settingsIgnoreSSL = [prefs boolForKey:@"ignoreSSL"];
    settingsDemomode = [prefs boolForKey:@"demomode"];
    settingsIdleOff = [prefs boolForKey:@"ildeOff"];
}

- (void)updateSettings
{
    settingsLocalUrl = localUrlTextField.text;
    settingsRemoteUrl = remoteUrlTextField.text;
    settingsUsername = usernameTextField.text;
    settingsPassword = passwordTextField.text;
    settingsIgnoreSSL = ignoreSSLSwitch.isOn;
    settingsDemomode = demomodeSwitch.isOn;
    settingsIdleOff = idleOffSwitch.isOn;
}

- (void)saveSettings
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:settingsLocalUrl forKey:@"localUrl"];
    [prefs setValue:settingsRemoteUrl forKey:@"remoteUrl"];
    [prefs setValue:settingsUsername forKey:@"username"];
    [prefs setValue:settingsPassword forKey:@"password"];
    [prefs setBool:settingsIgnoreSSL forKey:@"ignoreSSL"];
    [prefs setBool:settingsDemomode forKey:@"demomode"];
    [prefs setBool:settingsIdleOff forKey:@"idleOff"];
}

- (OpenHABDataObject*)appData
{
    id<OpenHABAppDataDelegate> theDelegate = (id<OpenHABAppDataDelegate>) [UIApplication sharedApplication].delegate;
    return [theDelegate appData];
}

@end
