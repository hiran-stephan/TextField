/**
 * Defines the main authentication route with support for parameterized navigation.
 *
 * ### Change summary:
 * - Updated `ROUTE_MAIN` to accept an additional `code` parameter.
 * - Added `code` property in `Main` and overridden `queryParams()` to include:
 *   ```
 *   mapOf(
 *       KEY_PARAM_FRIENDLYID to friendlyId,
 *       KEY_PARAM_CODE to code
 *   )
 *   ```
 *
 * ### Reason:
 * - Previously, during sign-off the app navigated to `ROUTE_SIGNON`, which incorrectly
 *   became the **root** of the navigation stack.
 * - Navigation should instead go to `ROUTE_MAIN`, but `ROUTE_MAIN` did not support
 *   passing `code`.
 * - This update allows `ROUTE_MAIN` to carry the `code` parameter and act as the
 *   correct root for post-sign-off navigation.
 *
 * ### Result:
 * - Maintains proper navigator hierarchy after sign-off.
 * - Enables dynamic route creation and deep link handling with `code` support.
 */
