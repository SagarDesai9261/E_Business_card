class FieldValidator {
  String titleValidator(String value) {
    print("DS>> "+ value);
    //Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    //RegExp regex = new RegExp(pattern.toString());
    if (value.isEmpty)
      return 'Full Name  cant\'t  be  Empty.';
    else if (value.length < 2) return 'Full Name Must be 2 character Long.';

    return null;
  }

  String subTitleValidator(String value) {
    Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regex = new RegExp(pattern.toString());
    if (value.isEmpty)
      return 'sub title  cant\'t  be  Empty.';
    else if (value.length < 2) return 'sub title Must be 2 character Long.';

    return null;
  }

  String firstNameValidator(String value) {
    Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regex = new RegExp(pattern.toString());
    if (value.isEmpty)
      return 'First Name  cant\'t  be  Empty.';
    else if (value.length < 2) return 'Name Must be 2 character Long.';
    // else if(regex.hasMatch(value))
    //   return 'Name Can\'t be a Number.';

    return "";
  }

  String nameValidator(String value) {
    Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regex = new RegExp(pattern.toString());

    if (value.isEmpty)
      return 'Name  cant\'t  be  Empty.';
    else if (value.length < 2) return 'Name Must be 2 character Long.';
    // else if(regex.hasMatch(value))
    //   return 'Name Can\'t be a Number.';

    return "";
  }

  String lastNameValidator(String value) {
    Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regex = new RegExp(pattern.toString());

    if (value.isEmpty)
      return 'Last Name  cant\'t  be  Empty.';
    else if (value.length < 2) return 'Last Name Must be 2 character Long.';
    return "";
  }

  String designationValidator(String value) {
    Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regex = new RegExp(pattern.toString());

    if (value.isEmpty)
      return 'designation  cant\'t  be  Empty.';
    else if (value.length < 2) return 'designation Must be 2 character Long.';
    // else if(regex.hasMatch(value))
    //   return 'Role Can\'t be a Number.';

    return null;
  }

  String addressValidator(String value) {
    if (value.isEmpty)
      return 'Address can\'t be Empty.';
    else if (value.length < 5) return 'Address must be 5 character long.';
    return "";
  }

  String emailValidator(String value) {
    Pattern pattern = r"^[A-Za-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$";
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value.toLowerCase()) || value.isEmpty)
      return 'Enter a valid email address.';
    return "";
  }

  String companyNameValidator(String value) {
    // Pattern pattern =
    //     r"^(\(([^)]+)\))?[[:punct:]]?\p{Lu}+(?:[\s'-]?[\p{L}\d]+)+(\(([^)]+)\))*$";
    // RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return 'Enter a valid Company Name.';
    return "";
  }

  String passwordValidator(String value) {
    if (value.isEmpty)
      return 'Password cant\'t  be  Empty.';
    else if (value.length < 4) return 'Password Must be 4 character Long.';
    return "";
  }

  String websiteValidator(String value) {
    Pattern pattern =
        r"^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$";
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value) || value.isEmpty)
      return 'Enter a valid website URL.';
    return "";
  }

  String pageUrlValidator(String value) {
    if (value.isEmpty) return 'Page URL cant\'t  be  Empty.';
    return null;
  }

  String businessValidator(String value) {
    if (value.isEmpty) return 'Business Or Organisation cant\'t  be  Empty.';
    return "";
  }

  String mobileNumberValidator(String value) {
    if (value.isEmpty)
      return 'Mobile Number cant\'t  be  Empty.';
    else if (value.length < 10) return 'Number Must be 10 Digit Long.';
    return "";
  }

  String phoneNumberValidator(String value) {
    if (value.isEmpty)
      return 'Phone Number cant\'t  be  Empty.';
    else if (value.length < 10) return 'Phone Must be 10 Digit Long.';
    return "";
  }
}
