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
          "id": 2422,
          "target_url": "http://instagram.com/p/***REMOVED***",
          "campaign_type": "instagram_liking",
          "payment_type": "like",
          "status": "درحال‌نمایش",
          "budget": 1000,
          "total_likes": 0
        },
        {
          "id": 2420,
          "target_url": "http://instagram.com/p/***REMOVED***",
          "campaign_type": "instagram_liking",
          "payment_type": "coin",
          "status": "رد‌شده",
          "budget": 1000,
          "total_likes": 0
        },
        {
          "id": 2419,
          "target_url": "http://instagram.com/p/***REMOVED***",
          "campaign_type": "instagram_liking",
          "payment_type": "coin",
          "status": "available",
          "budget": 1000,
          "total_likes": 0
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

### Getting Latest Campaign Classes
* **Method:** `GET`
* **Endpoint:** `/api/campaigns/new`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "campaign_classes": [
        {
          "id": 1092,
          "campaign_type": "instagram_liking",
          "payment_type": "like",
          "waiting": 0,
          "max_user_likes": 2000,
          "campaign_value": 10,
          "fields": {
            "description": false,
            "phone": false,
            "website": false,
            "address": false
          }
        },
        {
          "id": 1093,
          "campaign_type": "instagram_liking",
          "payment_type": "coin",
          "waiting": 15,
          "max_user_likes": 2000,
          "campaign_value": 5,
          "fields": {
            "description": true,
            "phone": true,
            "website": true,
            "address": true
          }
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
      "campaign_class_id": "1215",
      "target_url": "https://instagram.com/p/***REMOVED***",
      "budget": "1000",
      "description": "Ullam quam velit blanditiis hic id et. Id voluptas quae et ducimus corporis quis alias necessitatibus. Numquam omnis nulla et eos accusantium.",
      "phone": "09123456789",
      "website": "http://miller.co.uk",
      "address": "6485 Torp Rest, Palmerston NT 3825"
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
        "target_url": [
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
* Failure (when the selected campaign_class is not available)
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
        "id": 2578,
        "payment_type": "like",
        "coin_user_share": 0,
        "like_user_share": 5,
        "waiting": 0,
        "cover": "http://likenama.com/system/instagram_liking_campaigns/covers/000/000/001/original/11820650_383510488514384_162151818_n.jpg?1463292759",
        "description": "Sunt quo molestiae a neque sapiente. Alias rem ullam iure et explicabo modi. Sunt velit nisi hic incidunt voluptas et.",
        "phone": "09123456789",
        "website": "http://volkman.us",
        "address": "0260 Abshire Locks, Grafton NSW 0800"
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
      "access_token": "***REMOVED***"
    }
  }
  ```

#### Response
* Success (when user has liked the target):
  * **Content:**

    ```json
    {
      "user": {
        "username": "sample_username",
        "like_credit": 20000,
        "coin_credit": 10002
      }
    }
    ```
  * **Status:** `200`
* Failure (when user didn't like the target)
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

### Reporting a Campaign
* **Method:** `POST`
* **Endpoint:** `/api/campaigns/[CAMPAIGN-ID]/report`
* **Request Content:** `none`

#### Response
* Success (when the campaign gets reported):
  * **Content:** `none`
  * **Status:** `201`
* Failure (when user has reported the campaign before)
  * **Content:** `none`
  * **Status:** `200`

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
      "detail": {
        "code": "Omnis eos rerum ad et ut sapiente asperiores quae.",
        "product": {
          "id": 1522,
          "title": "Input Power Controller",
          "product_type": "Electric GPS Tuner78",
          "price": 76,
          "description": "Ipsam et suscipit labore omnis autem commodi. Nisi dignissimos enim nulla atque. Sint placeat et labore autem. Facere laboriosam voluptate officia necessitatibus distinctio. Corporis aut tempore pariatur quod qui."
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
          "شما اعتبار کافی ندارید"
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

Bundles
-------

### List all available Bundles
* **Method:** `GET`
* **Endpoint:** `/api/bundles`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "bundles": [
        {
          "bazaar_sku": "lurline",
          "price": 3,
          "coins": 1,
          "free_coins": 1
        },
        {
          "bazaar_sku": "desiree.larson",
          "price": 3,
          "coins": 1,
          "free_coins": 1
        },
        {
          "bazaar_sku": "alene_considine",
          "price": 3,
          "coins": 1,
          "free_coins": 1
        }
      ]
    }
    ```
  * **Status:** `200`
* Failure (when there is no bundle available)
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

### Purchasing A Bundle
* **Method:** `POST`
* **Endpoint:** `/api/bundles/[BAZAAR_SKU]/purchase`
* **Request Content:**

  ```json
  {
    "bundle": {
      "purchase_token": "djhs543jcdlfhw452"
    }
  }
  ```

#### Response
* Success:
  * **Content:** `none`
  * **Status:** `201`
* Failure (when the payment was unsuccessful)
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "پرداخت ناموفق بوده‌است"
        ]
      }
    }
    ```
  * **Status:** `422`

### Sending a Message
* **Method:** `POST`
* **Endpoint:** `/api/messages`
* **Request Content:**

  ```json
  {
    "message": {
      "email": "sample@example.com",
      "content": "Dignissimos quia provident similique dolores libero dolorem. Deleniti illum perferendis et veniam id nisi est. Ut tempora modi blanditiis quasi est aliquam.\nExcepturi inventore dolorum eos rem autem. Qui vitae aperiam animi optio quos veniam vero. Aut quo qui dolore sint."
    }
  }
  ```

#### Response
* Success:
  * **Content:** `none`
  * **Status:** `201`
* Failure (when the content length is invalid)
  * **Content:**

    ```json
    {
      "errors": [
        "متن‌پیام بلند است (حداکثر 500 کاراکتر)"
      ]
    }
    ```
  * **Status:** `422`
