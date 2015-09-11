Likenama API Documentation
==========================

Headers
-------

**Accept:** `application/vnd.likenama.v1,application/json`

**Content-type:** `application/json`

**Authorization:** `[USER'S auth_token]`

### Errors
* Invalid/Expired auth_token:

```json
{
  "errors": {
    "base": [
      "not authenticated"
    ]
  }
}
```
* HTTP Status Codes:
  * OK: `200`
  * Created: `201`
  * Not Found: `404`
  * Created: `201`
  * Unprocessable Entity: `422`
  * Server Error: `500`

Registration and logging
------------------------

### Signing up
**URL**: ```http://likenama.com/api/users/auth/instagram```


#### Response:
* Success:
 * **URL:**

  ```
  http://likenama.com/api/v1/users/auth/instagram/callback#access_token=46569720.5106fe6.31dm6ecbf60448f0ae396b8ffd2aa671&uid=T6S5tMRNp1FsDoUJtebR
  ```
  * **Access token:** `46569720.5106fe6.31dm6ecbf60448f0ae396b8ffd2aa671`

  * **UID:** `T6S5tMRNp1FsDoUJtebR`

* Failure:
  * Instagram Failure:
    * **URL:**

    ```
    http://likenama.com/api/v1/users/auth/instagram/callback?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request.&state=e900deb141cb46508838cee83840e5677f992f195517a7f4
    ```
  * App Failure:
    * **URL:**

    ```
    http://likenama.com/api/v1/users/auth/instagram/callback#error
    ```

### Signing in
* **Method:** `POST`
* **Endpoint:** `/api/sessions`
* **Request Content:**

  ```json
  {
    "user": {
      "uid": "DLju_zVSFb7Bfp5ZB6Lu"
    }
  }
  ```

#### Response
* Success:
  * **Content:**

    ```json
    {
      "session": {
        "auth_token": "NxPcphoB6EDaWmpJiz_H"
      }
    }
    ```
  * **Status:** `200`
* Failure
  * **Content:**

    ```json
    {
      "errors": {
        "base": [
          "the requested record(s) cannot be found"
        ]
      }
    }
    ```
  * **Status:** `404`

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
          "the requested record(s) cannot be found"
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
* Success (when user has liked the photo):
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
      "campaign_type": "instagram",
      "payment_type": "money_getter",
      "like_value": "97789",
      "total_likes": "0",
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
          "invalid url"
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
          "the requested record(s) cannot be found"
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
          "user has not liked the photo"
        ]
      }
    }
    ```
  * **Status:** `422`

Shop
----

### List All Products
* **Method:** `GET`
* **Endpoint:** `/api/campaigns/next`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "products": [
        {
          "id": 596,
          "title": "Electric Portable Bracket",
          "price": 3714,
          "description": "Numquam dolores omnis mollitia eius ut nesciunt placeat error. Placeat natus nihil et molestiae sed voluptatem. Ut provident dolores praesentium officiis veritatis quisquam. Commodi saepe et reiciendis nisi maiores nihil eos qui. Laboriosam voluptatem ducimus ut sunt quas rem fuga enim."
        },
        {
          "id": 599,
          "title": "Portable GPS Transmitter",
          "price": 8943,
          "description": "Corrupti quia debitis veniam dolorem. Et delectus sit provident hic. Deserunt vero molestiae occaecati dolore est neque unde. Facere molestiae qui repellendus nemo atque est consequatur."
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
          "the requested record(s) cannot be found"
        ]
      }
    }
    ```
  * **Status:** `404`

### Purchasing A Product
* **Method:** `POST`
* **Endpoint:** `/api/campaigns/[CAMPAIGN-ID]/purchase`
* **Request Content:** `none`

#### Response
* Success:
  * **Content:**

    ```json
    {
      "details": {
        "code": "Nihil ab qui harum dolorem unde velit dolores modi.",
        "description": "[\"Quod pariatur et laboriosam odio est. Aliquam corporis laboriosam ad aut fugiat quod quibusdam. Hic eum delectus harum quas qui quia doloremque. Doloremque architecto vel hic voluptas dicta quasi maiores ea.\", \"Nihil velit consequuntur molestias fuga ut. Quas quod molestiae culpa iste. Labore laborum recusandae consequatur aliquam quos dolorum fugiat error.\", \"Consequuntur voluptatem id mollitia magni impedit. In unde sapiente impedit rerum vel odio aperiam provident. Ratione est minima et doloremque consequatur. Quasi sed amet porro laborum hic ut. Itaque doloribus est et recusandae voluptatem.\"]",
        "product": {
          "id": 659,
          "title": "Video Controller",
          "price": 9719,
          "description": "Est ut sint ducimus cupiditate magni aperiam suscipit eaque. Laboriosam dolorem harum qui ut maxime quas. Sit minus unde eius saepe aliquid tempora eligendi. Quia ea omnis totam possimus aliquam amet explicabo aut."
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
          "the requested record(s) cannot be found"
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
          "doesn't have enough credit"
        ]
      }
    }
    ```
  * **Status:** `422`
