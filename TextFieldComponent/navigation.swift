accordionHeader = response.customerServicesActions.accordionHeader.takeIf { !it.isNullOrEmpty() },
        accordionActions = response.customerServicesActions.accordionActions.takeIf { !it.isNullOrEmpty() }
    
