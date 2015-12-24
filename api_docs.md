Likenama API Documentation V1
==========================

Request Headers
-------

**Accept:** `application/vnd.likenama.v1`

**Content-type:** `application/json`

**Authorization:** `[USER'S auth_token]`

**User-Agent:** `Likenama/[APP-VERSION] Android/[ANDROID-VERSION]`

### Errors
* Invalid/Expired auth_token:

```json
{
  "errors": {
    "base": [
      "ارتباط با سرور قطع شده‌است. دوباره وارد شوید"
    ]
  }
}
```
**Status:** `401`

* Locked account:

```json
{
  "errors": {
    "base": [
      "اکانت شما قفل شده‌است. برای اطلاعات بیشتر با پشتیبانی تماس بگیرید"
    ]
  }
}
```
**Status:** `401`

* HTTP Status Codes:
  * OK: `200`
  * Created: `201`
  * Not Found: `404`
  * Unprocessable Entity: `422`
  * Server Error: `500`
  * Deprecated: `410`
  * Unauthorized: `401`

Registration and logging
------------------------

### Signing up
**URL**: ```http://likenama.com/users/auth/instagram```


#### Response:
* Success:
 * **URL:**

  ```
  http://likenama.com/session#token=7av7qqxTdUcjCe4oS3sK46569725.5106fe6.31df6ecb062448f8ae396b8ffd2ca671
  ```
  * **Instagram Access Token:** `46569725.5106fe6.31df6ecb062448f8ae396b8ffd2ca671`

  * **App Access Token:** `7av7qqxTdUcjCe4oS3sK`

* Failure:
  * Instagram Failure:
    * **URL:**

    ```
    http://likenama.com/users/auth/instagram/callback?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request.&state=feded9a3593be61a726d9a14fddadf7604de80eba540f12f
    ```
  * App Failure:
    * **URL:**

    ```
    http://likenama.com/users/auth/instagram/callback#error
    ```

Campaigns
---------

### All User's Campaigns
* **Method:** `GET`
* **Endpoint:** `/api/campaigns`
* **Request Content:** `none`

#### Response
* Success (user has some campaigns):
  * **Content:**

    ```json
    {
      "campaigns": [
        {
          "id": 4007,
          "campaign_type": "instagram",
          "payment_type": "like_getter",
          "available": null,
          "verified": null,
          "budget": 1000,
          "total_likes": 0,
          "created_at": "2015-09-11T18:49:26.444Z"
        },
        {
          "id": 4008,
          "campaign_type": "instagram",
          "payment_type": "like_getter",
          "available": false,
          "verified": true,
          "budget": 1000,
          "total_likes": 0,
          "created_at": "2015-09-11T18:49:30.266Z"
        },
        {
          "id": 4011,
          "campaign_type": "instagram",
          "payment_type": "like_getter",
          "available": true,
          "verified": true,
          "budget": 1000,
          "total_likes": 0,
          "created_at": "2015-09-11T18:49:45.032Z"
        }
      ]
    }
    ```
  * **Status:** `200`
* Failure (when there's no campaign available)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "مورد درخواست‌شده یافت نشد"
        ]
      }
    }
    ```
  * **Status:** `404`

### Getting Latest Prices
* **Method:** `GET`
* **Endpoint:** `/api/campaigns/new`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "prices": [
        {
          "campaign_type": "instagram",
          "payment_type": "money_getter",
          "campaign_value": 50
        },
        {
          "campaign_type": "instagram",
          "payment_type": "like_getter",
          "campaign_value": 50
        }
      ]
    }
    ```
  * **Status:** `200`

### Creating a Campaign
* **Method:** `POST`
* **Endpoint:** `/api/campaigns`
* **Request Content:**

  ```json
  {
    "campaign": {
      "campaign_type": "instagram",   // Always the same
      "payment_type": "money_getter", // Always the same
      "budget": "1000",
      "instagram_detail_attributes": {
        "url": "https://instagram.com/p/***REMOVED***",
        "description": "In voluptatem esse dolor qui qui et voluptatibus. Est dolores maiores dolorem molestias neque odit a velit. Blanditiis mollitia accusantium debitis adipisci omnis.",
        "phone": "4173358",
        "website": "http://kleinroob.com",
        "address": "56122 Delphia Light, Burnie TAS 2601"
      }
    }
  }
  ```

#### Response
* Success:
  * **Content:** `none`
  * **Status:** `201`
* Failure (when Instagram url is wrong)
  * **Content:**

    ```json
    {
      "errors": {
        "instagram_detail.url": [
          "آدرس تصویر اینستاگرام اشتباه است"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when user has not enough credit to create a campaign)
  * **Content:**

    ```json
    {
      "errors": {
        "budget": [
          "شما اعتبار کافی ندارید"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when the budget is not enough even for a like)
  * **Content:**

    ```json
    {
      "errors": {
        "budget": [
          "باید اعتبار بیشتری برای کمپین خود اختصاص دهید"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when no parameter respective to Instagram gets sent)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "اطلاعات واردشده برای ساخت کمپین کافی نیست"
        ]
      }
    }
    ```
  * **Status:** `422`

### Next Campaign
* **Method:** `GET`
* **Endpoint:** `/api/campaigns/next`
* **Request Content:** `none`

#### Response
* Success (when there's a campaign available):
  * **Content:**

    ```json
    {
      "campaign": {
        "id": 4018,
        "campaign_type": "instagram",
        "payment_type": "money_getter",
        "value": 20,
        "waiting": 10,
        "instagram_detail": {
          "url": "https://instagram.com/p/***REMOVED***",
          "photo_url": "https://scontent.cdninstagram.com/hphotos-xfa1/t51.2885-15/s640x640/sh0.08/e35/11820650_383510488514384_162151818_n.jpg",
          "description": "Fuga in quis et autem ipsa dicta atque. Vel est laudantium minima error voluptas aliquam. Omnis et velit veritatis libero aut. Ab itaque recusandae inventore aperiam debitis. Consequuntur voluptas et nam quisquam.",
          "phone": "1786032",
          "website": "http://swift.biz",
          "address": "1418 Cheyenne Cliffs, Braddon ACT 3300"
        }
      }
    }
    ```
  * **Status:** `200`
* Failure (when there's no campaign available)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "مورد درخواست‌شده یافت نشد"
        ]
      }
    }
    ```
  * **Status:** `404`

### Like a Campaign
* **Method:** `POST`
* **Endpoint:** `/api/campaigns/[CAMPAIGN-ID]/like`
* **Request Content:**

  ```json
  {
    "like": {
      "instagram_access_token": "***REMOVED***"
    }
  }
  ```

#### Response
* Success (when user has liked the photo):
  * **Content:**

    ```json
    {
      "user": {
        "uid": "2w-stzxfPAUhJdD7daN7",
        "like_credit": 20000,
        "coin_credit": 10020
      }
    }
    ```
  * **Status:** `200`
* Failure (when user didn't like the photo)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "این کمپین لایک نشده است"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when during the action, the campaign ran out of budget)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "بودجه این کمپین به پایان رسیده‌است"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when during the action, the campaign got unverified)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "این کمپین به تایید مدیریت نرسیده‌است"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when during the action, the campaign got unavailable)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "این کمپین به پایان رسیده‌است"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when the period between each like isn't enough)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "بین هر لایک باید چند ثانیه صبر کنید"
        ]
      }
    }
    ```
  * **Status:** `422`
* Failure (when the instagram access token is invalid)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "ارتباط با اینستاگرام قطع شده‌است. دوباره وارد شوید"
        ]
      }
    }
    ```
  * **Status:** `401`
* Failure (when during the action, the campaign's source picture got deleted)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "این کمپین دیگر موجود نیست"
        ]
      }
    }
    ```
  * **Status:** `422`

Shop
----

### List All Products
* **Method:** `GET`
* **Endpoint:** `/api/products`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "products": [
        {
          "id": 54,
          "title": "Remote Kit",
          "product_type": "mobiletopup",
          "price": 6398,
          "description": "Quod sequi placeat laudantium ea. Magnam velit sunt qui aspernatur molestias voluptatem laudantium sunt. Totam dolorum deleniti ab unde maxime quam numquam."
        },
        {
          "id": 55,
          "title": "Gel Output Bridge",
          "product_type": "mobiletopup",
          "price": 9527,
          "description": "Odit voluptas quasi omnis est nesciunt aut. Amet veritatis impedit consectetur aspernatur eveniet error aut. Eligendi dolorem numquam sit totam autem iusto."
        },
        {
          "id": 56,
          "title": "Remote Gel Transmitter",
          "product_type": "mobiletopup",
          "price": 9239,
          "description": "Consectetur laborum vel architecto enim reprehenderit fuga quae libero. Et quos consequuntur est illum qui amet corrupti. Voluptatem quam dolorum iure sit qui fuga nostrum."
        },
        {
          "id": 57,
          "title": "Gel Mount",
          "product_type": "mobiletopup",
          "price": 7942,
          "description": "Et nulla expedita numquam amet facilis aut. Soluta et consequatur consectetur eaque autem eveniet sed quasi. Quidem accusantium a at reprehenderit ratione consequatur dolore magni. Odit quod libero veniam aut quis sit ut."
        }
      ]
    }

    ```
  * **Status:** `200`
* Failure (when there are no products available)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "مورد درخواست‌شده یافت نشد"
        ]
      }
    }
    ```
  * **Status:** `404`

### Purchasing A Product
* **Method:** `POST`
* **Endpoint:** `/api/products/[PRODUCT-ID]/purchase`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "details": {
        "code": "Fugit qui deleniti perferendis ullam.",
        "description": "[\"Est doloremque eos accusantium dicta. Veritatis quos voluptatem doloremque qui rerum sit. Quia minus non vitae cumque est provident. Reiciendis sint beatae quasi et in et.\", \"Aut quaerat autem impedit odit aliquam nam similique. Et error numquam corrupti eaque ratione delectus amet. Aut in corrupti aut quas sed et. Numquam odit et ullam veniam voluptatum esse natus.\", \"Expedita assumenda temporibus ea qui et. Amet eos sunt ipsum aliquam nihil in. Perspiciatis reiciendis officia assumenda qui sed qui delectus. Consequatur amet explicabo voluptate et expedita soluta. Et dolore assumenda ut placeat.\"]",
        "product": {
          "id": 112,
          "title": "Digital Auto Case",
          "product_type": "mobiletopup",
          "price": 1662,
          "description": "Quod omnis quam dolore eum asperiores perspiciatis voluptates. At rem enim iusto voluptas laboriosam possimus. Accusantium repudiandae aperiam earum tempore ab velit."
        }
      }
    }
    ```
  * **Status:** `200`
* Failure (when it's out of stock)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "مورد درخواست‌شده یافت نشد"
        ]
      }
    }
    ```
  * **Status:** `404`
* Failure (when user doesn't have enough credit)
  * **Content:**

    ```json
    {
      "errors": {
        "coin_credit": [
          "اعتبار شما برای خرید این محصول کافی نیست"
        ]
      }
    }
    ```
  * **Status:** `422`

User
----

### Get the user's own details
* **Method:** `GET`
* **Endpoint:** `/api/users/self`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "user": {
        "username": "phoebe_buffay",
        "like_credit": 20000,
        "coin_credit": 10000
      }
    }
    ```
  * **Status:** `200`
