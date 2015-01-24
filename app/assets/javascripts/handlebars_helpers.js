Handlebars.registerHelper("is_modulus", function(lvalue, rvalue, options) {
    lvalue = parseFloat(lvalue);
    rvalue = parseFloat(rvalue);

    return (lvalue % rvalue) == 0;
});

Handlebars.registerHelper("checkedIf", function (condition) {
    return (condition) ? "checked" : "";
});

Handlebars.registerHelper("expandIf", function (condition) {
    return (condition) ? "in" : "";
});
