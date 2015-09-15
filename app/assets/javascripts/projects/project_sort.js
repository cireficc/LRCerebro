$(document).on('change', '#project_sort', function(e) {
	
	var projectTabsContent = $("#project_tabs_content");
	
	var pending = projectTabsContent.find("#pending").find("#project_list");
	var approved = projectTabsContent.find("#approved").find("#project_list");
	
	var pendingProjects = pending.find('[name="project_panel"]');
	var approvedProjects = approved.find('[name="project_panel"]');
	
	var sortMethod = $(this).val();
	
	switch (sortMethod) {
	case "submitted_at":
		pendingProjects.sort(submittedAt); approvedProjects.sort(submittedAt);
		break;
	case "updated_at":
		pendingProjects.sort(updatedAt); approvedProjects.sort(updatedAt);
		break;
	case "script_due":
		pendingProjects.sort(scriptDue); approvedProjects.sort(scriptDue);
		break;
	case "first_training":
		pendingProjects.sort(firstTraining); approvedProjects.sort(firstTraining);
		break;
	case "last_editing":
		pendingProjects.sort(lastEditing); approvedProjects.sort(lastEditing);
		break;
	case "project_due":
		pendingProjects.sort(projectDue); approvedProjects.sort(projectDue);
		break;
	case "publish_due":
		pendingProjects.sort(publishDue); approvedProjects.sort(publishDue);
		break;
	case "faculty_name":
		pendingProjects.sort(facultyLastName); approvedProjects.sort(facultyLastName);
		break;
	case "course_name":
		pendingProjects.sort(courseName); approvedProjects.sort(courseName);
		break;
	case "project_type":
		pendingProjects.sort(projectType); approvedProjects.sort(projectType);
		break;
	case "project_name":
		pendingProjects.sort(projectName); approvedProjects.sort(projectName);
		break;
	default:
		pendingProjects.sort(submittedAt); approvedProjects.sort(submittedAt);
		break;
	}
	
	pendingProjects.appendTo(pending);
	approvedProjects.appendTo(approved);
});

function submittedAt (a, b) {
	var dateA = new Date ($(a).find("#submitted_at").text());
	var dateB = new Date ($(b).find("#submitted_at").text());
	return (dateA > dateB) ? 1 : (dateA < dateB) ? -1 : 0;
};

function updatedAt (a, b) {
	var dateA = new Date ($(a).find("#updated_at").text());
	var dateB = new Date ($(b).find("#updated_at").text());
	return (dateA > dateB) ? 1 : (dateA < dateB) ? -1 : 0;
};

function scriptDue(a, b) {
	var dateA = new Date ($(a).find('#script_due').val());
	var dateB = new Date ($(b).find('#script_due').val());
	return (dateA > dateB) ? 1 : (dateA < dateB) ? -1 : 0;
};

function firstTraining(a, b) {
	var dateA = new Date ($(a).find('#first_training').val());
	var dateB = new Date ($(b).find('#first_training').val());
	return (dateA > dateB) ? 1 : (dateA < dateB) ? -1 : 0;
};

function lastEditing(a, b) {
	var dateA = new Date ($(a).find('#last_editing').val());
	var dateB = new Date ($(b).find('#last_editing').val());
	return (dateA > dateB) ? 1 : (dateA < dateB) ? -1 : 0;
};

function projectDue(a, b) {
	var dateA = new Date ($(a).find('#due').val());
	var dateB = new Date ($(b).find('#due').val());
	return (dateA > dateB) ? 1 : (dateA < dateB) ? -1 : 0;
};

function publishDue(a, b) {
	var dateA = new Date ($(a).find('#viewable_by').val());
	var dateB = new Date ($(b).find('#viewable_by').val());
	return (dateA > dateB) ? 1 : (dateA < dateB) ? -1 : 0;
};

function facultyLastName (a, b) {
	var valA = $(a).find("#project_owner").text();
	var valB = $(b).find("#project_owner").text();
	return alphaNumericSort(valA, valB);
};

function courseName (a, b) {
	var valA = $(a).find("#course_name").text();
	var valB = $(b).find("#course_name").text();
	return naturalSort(valA, valB);
};

function projectType (a, b) {
	var valA = $(a).find("#project_type").text();
	var valB = $(b).find("#project_type").text();
	return alphaNumericSort(valA, valB);
};

function projectName (a, b) {
	var valA = $(a).find("#project_name").text();
	var valB = $(b).find("#project_name").text();
	return naturalSort(valA, valB);
};