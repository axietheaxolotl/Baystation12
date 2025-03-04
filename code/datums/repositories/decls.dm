var/global/repository/decls/decls_repository = new


/repository/decls
	var/static/list/fetched_decls = list()
	var/static/list/fetched_decl_types = list()
	var/static/list/fetched_decl_subtypes = list()


/repository/decls/proc/get_decl(var/decl_type)
	. = fetched_decls[decl_type]
	if (!.)
		if (is_abstract(decl_type))
			return
		. = new decl_type
		fetched_decls[decl_type] = .

		var/decl/decl = .
		if(istype(decl))
			decl.Initialize()


/repository/decls/proc/get_decls(var/list/decl_types)
	. = list()
	for (var/decl_type in decl_types)
		var/decl = get_decl(decl_type)
		if (!decl)
			continue
		.[decl_type] = decl


/repository/decls/proc/get_decls_unassociated(var/list/decl_types)
	. = list()
	for (var/decl_type in decl_types)
		var/decl = get_decl(decl_type)
		if (!decl)
			continue
		. += decl


/repository/decls/proc/get_decls_of_type(var/decl_prototype)
	. = fetched_decl_types[decl_prototype]
	if(!.)
		. = get_decls(typesof(decl_prototype))
		fetched_decl_types[decl_prototype] = .


/repository/decls/proc/get_decls_of_subtype(var/decl_prototype)
	. = fetched_decl_subtypes[decl_prototype]
	if(!.)
		. = get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes[decl_prototype] = .


/decl
	abstract_type = /decl


/decl/proc/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)


/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	crash_with("Prevented attempt to delete a decl instance: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE // Prevents Decl destruction
