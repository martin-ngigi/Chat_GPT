# chat_gpt

An Open AI chatbot in  Flutter.

## Links
- [Youtube](https://www.youtube.com/watch?v=i8TE4BmG3l4&list=PL333BSi_KSQ_AqZQR98tAjxcXYMmPyr8E&index=2&ab_channel=CodingwithHadi)
- [Github](https://github.com/hadikachmar3/chatGPT_flutter_course/)

## Running the web app
- Navigate to current project directory i.e. C:\Users\Administrator\AndroidStudioProjects\Chat_GPT>
- Then run the following command so as to run web app

```
flutter run -d chrome
```

## API
- [API Key](https://platform.openai.com/account/api-keys)
- [Making API request doc](https://platform.openai.com/docs/api-reference/making-requests)

## Sample API request :
1. API Request
- POST 
- Endpoint -> https://api.openai.com/v1/completions
- Content-Type: application/json
- Authorization: Bearer YOUR_API_KEY
- Body: 
```
{
    "model": "text-davinci-003", 
    "prompt": "What is flutter ?", 
    "temperature": 0, "max_tokens": 100
}
```
- sample response:
```
{
    "id": "cmpl-6hy6wbpHC8KLRQwhik0QR9aH6ojz5",
    "object": "text_completion",
    "created": 1675937190,
    "model": "text-davinci-003",
    "choices": [
        {
            "text": "\n\nFlutter is an open-source mobile application development framework created by Google. It is used to develop applications for Android, iOS, Windows, Mac, Linux, Google Fuchsia, and the web from a single codebase. Flutter uses the Dart programming language for developing apps. It also provides a rich set of widgets for creating beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.",
            "index": 0,
            "logprobs": null,
            "finish_reason": "stop"
        }
    ],
    "usage": {
        "prompt_tokens": 5,
        "completion_tokens": 88,
        "total_tokens": 93
    }
}
```

2. Model Requests
- GET
- Endpoint -> https://api.openai.com/v1/models
- Authorization: Bearer YOUR_API_KEY
- Response :
```
{
    "object": "list",
    "data": [
        {
            "id": "babbage",
            "object": "model",
            "created": 1649358449,
            "owned_by": "openai",
            "permission": [
                {
                    "id": "modelperm-49FUp5v084tBB49tC4z8LPH5",
                    "object": "model_permission",
                    "created": 1669085501,
                    "allow_create_engine": false,
                    "allow_sampling": true,
                    "allow_logprobs": true,
                    "allow_search_indices": false,
                    "allow_view": true,
                    "allow_fine_tuning": false,
                    "organization": "*",
                    "group": null,
                    "is_blocking": false
                }
            ],
            "root": "babbage",
            "parent": null
        }
    }
}
```