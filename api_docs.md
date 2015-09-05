Likenama API Documentation
==========================

### Signing up
**URL**: http://likenama.com/api/users/auth/instagram


#### Response:
* Success:
 * **URL:**
  `http://likenama.com/api/users/auth/instagram/callback#access_token=46569725.5106fe6.31dm6ecbf62448f0ae396b8ffd2ea671&uid=T6S5tMRNp1FsDoUJtebR`

  * **Access token:** `R3thaxCazAim2QKNg92x-instagram-46569725.5109fe6.9d58de87453144cb8z4f28af6d90a92e`

  * **UID:** ```T6S5tMRNp1FsDoUJtebR```

* Failure:
  * Instagram Failure:
    * **URL:**
    `http://localhost:3000/api/users/auth/instagram/callback?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request.&state=e900deb141cb46508838cee83840e5677f992f195517a7f4`
  * App Failure:
    * **URL:**
    `http://localhost:3000/api/users/auth/instagram/callback#error`

### Signing in
* **Method:** POST
* **Endpoint:** `/api/sessions`
* **Request Content:**

```
{
  "user": {
    "uid": "DLju_zVSFb7Bfp5ZB6Lu"
  }
}
```

#### Response
* Success:
  * **Content:**

    ```
    {
      "session": {
        "auth_token": "NxPcphoB6EDaWmpJiz_H"
      }
    }
    ```
  * **Status:** `200`
* Failure
  * **Content:**

    ```
    {
      "errors": {
        "base": [
          "user not registered"
        ]
      }
    }
    ```

### Next Campaign
* **Method:** POST
* **Endpoint:** `/api/campaigns/next`
* **Request Content:** `none`

#### Response
* Success:
