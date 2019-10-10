import Foundation

extension Fynzo {
    
    struct ValidationMessage {
        static let enterEmail = "Please enter your email address."
        static let enterPassword = "Please enter password."
        static let passwordLength = "Password must contain at least 8 characters."
        static let enterValidEmail = "Please enter valid email address."
        static let enterPhoneNumber = "Please enter phone number."
        static let validPhoneNumber = "Phone number must contain at least 8 digits."
        static let enterOldPassword = "Please enter old password."
        static let enterNewPassword = "Please enter new password."
        static let enterConfirmPassword = "Please enter confirm password."
        static let passwordContain = "Password must contain one capital letter."
        static let passwordMustMatch = "Password and confirm password must match"
        static let newAndConfirmPasswordMustMatch = "The new password and confirm password do not match."
        static let passwordMustContainAtleast = "Password must contain at least one upper case, one number and one special character."
        static let enterFullName = "Please enter your first name."
        static let enterLastName = "Please enter your last name."
        static let enterName = "Please enter your full name."
        static let enterValidName = "Please enter a valid name."
        static let enterMobile = "Please enter mobile number."
        static let enterValidMobile = "Please enter valid mobile number."
        static let enterLicenceNumber = "Please enter licence number."
        static let enterValidLicenceNumber = "Please enter valid licence number."
        static let enterPermanentAddress = "Please enter permanent address."
        static let enterMessage = "Please enter some message."
        static let agreeTermsAndConditions = "Please select Terms and conditions, before the start!"
        static let selectEventImage = "Please select event image."
        static let enterEventName = "Please enter event name."
        static let enterStartTime = "Please enter start time."
        static let enterStartDate = "Please enter start date."
        static let enterLocation = "Please enter event location."
        static let startDateMustBeFuture = "Start date must be future date."
        static let endDateMustBeFuture = "End date must be future date."
        static let endDateMustBeGreateThanStartDate = "End date must be greater than start date."
        static let enterEventPrice = "Please enter Event Ticket Price."
        static let enterDescription = "Please enter description."
        static let enterdob = "Please enter date of birth."
        static let selectProvince = "Please select province."
        static let enterCity = "Please enter city."
        static let enterAddressLineOne = "Please enter billing address."
        static let enterPostalCode = "Please enter postal code."
        static let enterFynzoAttendies = "Please enter Fynzo attendees"
        static let enterMaxAttendies = "Please enter max attendees"
        static let enterPrice = "Please enter price"
        static let enterReferalCode = "Please enter referal code"
        static let FynzoAttendiesCount = "Fynzo attendees count cannot be greater than max attendees"
        static let enterSomeAmount = "Please enter some amount."
        static let minimumAmount = "Amount should be atleast $5."
    }
    
    struct AlertMessages {
        static let noInternetConnection = "No internet connection"
        static let notAuthenticated = "You are not authenticated user to use app."
        static let logoutMessage = "Are you sure you want to logout?"
        static let deviceDoesNotSupportCamera = "This device doesn't support camera"
        static let congratulation = "Congratulation"
        static let signUpSuccess = "You have successfully Registered with Fynzo! A verification link has been sent to your inbox, please verify your email before login."
        static let verifyEmail = "Please verify your email"
        static let forgotPasswordLinkSent = " A Password Reset link has been sent on your registered email id, please reset your password!"
    }
    
    struct ButtonTitle {
        static let cancel = "Cancel"
        static let yes = "Yes"
        static let ok = "OK"
        static let no = "No"
        static let done = "Done"
        static let settings = "Settings"
        static let forgotPassword = "Forgot Password?"
        static let register = "Register"
        static let show = "Show"
        static let hide = "Hide"
        static let send = "Send"
        static let resend = "Resend"
        static let changePassword = "Change Password"
        static let resetPassword = "Reset Password?"
        static let toChangeYourPassword = "To change your password, enter your old and new password fields below."
    }
    
    struct LabelText {
        static let email = "Email"
        static let firstName = "First Name"
        static let lastName = "Last Name"
        static let password = "Password"
        static let fullName = "Full name(shown to your friend)"
        static let referralId = "Referral ID(optional)"
        static let agreeTo = "Agree to "
        static let termAndConditions = "terms & conditions"
        static let noInternetOpenSetting = "Sorry! Internet connection required. Please tap on settings and turn on your internet."
        static let home = "Home"
        static let setting = "Settings"
        static let help = "Help"
        static let contactUs = "Contact Us"
        static let chatWithUs = "Chat With Us"
        static let logout = "Logout"
        static let account = "Account"
        static let plan = "Plan"
        static let app = "App"
        static let uploadSetting = "Upload Setting"
        static let Email = "Email"
        static let name = "Name"
        static let startDate = "Start Date"
        static let endDate = "End Date"
        static let version = "Version"
        static let autoUpload = "Auto Upload"
    }
    
    struct ApiKey {
        static let id = "_id"
        static let status = "status"
        static let success = "success"
        static let data = "data"
        static let token = "token"
        static let email = "email"
        static let password = "password"
        static let firstName = "firstName"
        static let lastName = "lastName"
    }
    
    struct ValidationStrings {
        static let alphabets = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ-. ")
    }
    
    struct NavigationTitle {
        static let signUp = "Sign up"
        static let forgotPassword = "Forgot password"
    }
    
    struct Placeholder {
        static let accountNumber = "Account number"
    }
}
