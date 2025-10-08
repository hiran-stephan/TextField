/**
 Trims the navigation stack to the nearest bottom-navigation boundary.

 - Parameter matchingRouter: The router for the current navigation context.

 ### Behavior:
 - Scans backward in the stack to find the last bottom-nav boundary.
 - Removes all items above that boundary.
 - Treats authentication and sign-on as bottom-nav roots for clear-stack flows.

 ### Result:
 Prevents clearing valid tab roots and maintains correct navigation hierarchy.
 */


/**
 Determines if a past navigation item should be treated as a bottom-nav boundary.

 - Parameters:
   - matchingRouter: Router for the current domain.
   - pastItem: Stack item being evaluated.
   - clearStack: Indicates if the check is part of a clear-stack flow.

 ### Behavior:
 - Returns early if the router already supports bottom navigation.
 - For clear-stack flows, also treats auth/signon as bottom-nav roots.
 - Otherwise, checks the resolved router for bottom-nav support.

 ### Result:
 Prevents over-trimming and flicker during tab and auth transitions.
 */
