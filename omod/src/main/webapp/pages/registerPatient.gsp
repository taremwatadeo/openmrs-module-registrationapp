<%
    if (emrContext.authenticated && !emrContext.currentProvider) {
        throw new IllegalStateException("Logged-in user is not a Provider")
    }
    ui.decorateWith("emr", "standardEmrPage")
    ui.includeJavascript("emr", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("emr", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("emr", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("emr", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("emr", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22);
    ui.includeCss("mirebalais", "simpleFormUi.css", -200)

    def genderOptions = [ [label: ui.message("emr.gender.M"), value: 'M'],
                          [label: ui.message("emr.gender.F"), value: 'F'] ]
%>
${ ui.includeFragment("emr", "validationMessages")}

<script type="text/javascript">
    jQuery(function() {
        KeyboardController();
    });
</script>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("registrationapp.registration.label") }", link: "${ ui.pageLink("registrationapp", "registerPatient") }" }
    ];

    var testFormStructure = "${formStructure}";
</script>

<div id="content" class="container">
    <h2>
        ${ ui.message("registrationapp.registration.label") }
    </h2>

    <form id="registration" method="POST">
        <section id="demographics">
            <span class="title">Demographics</span>

            <fieldset>
                <legend>Name</legend>
                <h3>What's the patient's name?</h3>
                <% nameTemplate.lineByLineFormat.each { name -> %>
                    ${ ui.includeFragment("emr", "field/text", [
                            label: ui.message("emr.person." + name),
                            formFieldName: name,
                            left: true])}

                <% } %>
                <input type="hidden" name="preferred" value="true"/>
            </fieldset>

            <fieldset>
                <legend>${ ui.message("emr.gender") }</legend>
                ${ ui.includeFragment("emr", "field/radioButtons", [
                        label: "What's the patient's gender?",
                        formFieldName: "gender",
                        options: genderOptions
                ])}
            </fieldset>

            <fieldset>
                <legend>Age</legend>
                <h3>What's the patient's age?</h3>
                ${ ui.includeFragment("emr", "field/text", [
                        label: ui.message("emr.retrospectiveCheckin.checkinDate.day.label"),
                        formFieldName: "birthDay",
                        left: true])}
                ${ ui.includeFragment("emr", "field/text", [
                        label: ui.message("emr.retrospectiveCheckin.checkinDate.month.label"),
                        formFieldName: "birthMonth",
                        left: true])}
                ${ ui.includeFragment("emr", "field/text", [
                        label: ui.message("emr.retrospectiveCheckin.checkinDate.year.label"),
                        formFieldName: "birthYear",
                        left: true])}
            </fieldset>
            
            <% if (enableOverrideOfAddressPortlet == 'false') { %>
	            <fieldset>
	                <legend>${ ui.message("Person.address") }</legend>
	                <h3>What is the patient's address?</h3>
	                <% addressTemplate.lines.each { line -> %>
	                    <% line.each { token -> %>
	                        <% if (token.isToken == addressTemplate.layoutToken) { %>
			                    ${ ui.includeFragment("emr", "field/text", [
			                            label: ui.message(token.displayText),
			                            formFieldName: token.codeName,
			                            initialValue: addressTemplate.elementDefaults.get(token.codeName),
			                            left: true])}
			                <% } %>
	                    <% } %>
	                <% } %>
	            </fieldset>
            <% } %>
            
        </section>
        <!-- read configurable sections from the json config file-->
        <% formStructure.sections.each { structure ->
            def section = structure.value
            def questions=section.questions
        %>
            <section id="${section.id}">
                <span class="title">${ui.message(section.label)}</span>
                    <% questions.each { question ->
                        def fields=question.value.fields
                    %>
                        <fieldset>
                            <legend>${ ui.message(question.value.legend)}</legend>
                            <% fields.each { field -> %>
                                ${ ui.includeFragment(field.fragmentRequest.providerName, field.fragmentRequest.fragmentId, [
                                        label:ui.message(field.label),
                                        formFieldName: field.formFieldName,
                                        left: true])}
                            <% } %>
                        </fieldset>
                    <% } %>
            </section>
        <% } %>
        <div id="confirmation">
            <span class="title">Confirm</span>
            <div id="confirmationQuestion">
                Confirm submission? <p style="display: inline"><input type="submit" class="confirm" value="Yes" /></p> or <p style="display: inline"><input id="cancelSubmission" class="cancel" type="button" value="No" /></p>
            </div>
            <div class="before-dataCanvas"></div>
            <div id="dataCanvas"></div>
            <div class="after-data-canvas"></div>
        </div>
    </form>
</div>