# Stage 2: Manual resources with AWS CLI

## Environment

- Date: 10/30/2026
- OS: Windows 11
- Floci version: v2.3.0
- AWS CLI version: v2.38.4

## Setup

- Floci running and the session configured as in Stage 1 (dummy credentials, endpoint through `AWS_ENDPOINT_URL`)

```shell
. .\env.ps1
aws s3 ls
```

## Exercises

### 1. S3: upload, inspect, retrieve

- Commands: `aws s3 mb s3://my-bucket`, `aws s3 cp`, `aws s3 ls`, `aws s3api head-object`
- Result: the bucket was created, `dummy.md` was uploaded (19 bytes) and listed with a summary. `head-object` showed the size, content type (`text/markdown`) and ETag

```shell
aws s3 cp .\dummy.md s3://my-bucket/dummy.md
aws s3 ls s3://my-bucket --recursive --human-readable --summarize
aws s3api head-object --bucket my-bucket --key dummy.md
```

- Verified the content by downloading the object and comparing SHA256 hashes. Both were `9648877586531EF31C5EA9AD5DDD0CC72131020BA34960663FF69131FD560F54`

```shell
aws s3 cp s3://my-bucket/dummy.md ./downloaded.md
Get-FileHash .\dummy.md
Get-FileHash .\downloaded.md
```

### 2. SQS: send, receive, inspect

- Commands: `aws sqs create-queue`, `aws sqs send-message`, `aws sqs receive-message`, `aws sqs get-queue-attributes`, `aws sqs list-queues`
- Result: the queue was created and the message `teste` was sent. `receive-message` returned it with the same body and MD5 (`698dc19d489c4e4db73e28a713eab07b`)

```shell
aws sqs create-queue --queue-name my-queue
aws sqs send-message --queue-url http://localhost:4566/000000000000/my-queue --message-body "teste"
aws sqs receive-message --queue-url http://localhost:4566/000000000000/my-queue
aws sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/my-queue
```

- A second `receive-message` right after returned nothing: the message is hidden for the visibility timeout (30 seconds), not deleted. `get-queue-attributes` later showed `ApproximateNumberOfMessages: 1`, so it had become visible again
- The message was never acknowledged with `delete-message`. It was only removed because the whole queue was deleted

## Dependencies and cleanup order

- The bucket and the queue are independent, so they can be removed in any order
- Inside S3, the object must be deleted before the bucket, because `aws s3 rb` fails on a non-empty bucket

## Commands that change state


| Changes state                                                                                    | Read-only                                             |
| ------------------------------------------------------------------------------------------------ | ----------------------------------------------------- |
| `aws s3 mb`, `aws s3 cp` (upload), `aws s3 rm`, `aws s3 rb`                                      | `aws s3 ls`, `aws s3api head-object`                  |
| `aws sqs create-queue`, `aws sqs send-message`, `aws sqs delete-queue`, `aws sqs delete-message` | `aws sqs get-queue-attributes`, `aws sqs list-queues` |


- `aws s3 cp` changes state only when the destination is S3. A download only writes a local file
- `aws sqs receive-message` deletes nothing, but it changes state: the message becomes invisible for the visibility timeout and can be received again afterwards

## Problems and notes

- `aws s3` and `aws s3api` are different command sets. `aws s3` has the high-level commands (`mb`, `cp`, `ls`, `rm`, `rb`). `aws s3api` has the raw API operations such as `head-object`. `aws s3 head-object` is not a valid command
- S3 keys are literal strings, not file paths. `head-object --key .\dummy.md` returned 404 because the key is `dummy.md`
- `create-queue` returned the URL `http://floci:4566/...`, while the commands used `http://localhost:4566/...`. Both worked because Floci identifies the queue by account ID and name
- `aws sqs delete-queue` printed nothing on success. The empty result of `list-queues` is the confirmation

## Cleanup

```shell
aws s3 rm s3://my-bucket/dummy.md
aws s3 rb s3://my-bucket
aws sqs delete-queue --queue-url http://localhost:4566/000000000000/my-queue
aws s3 ls
aws sqs list-queues
```

- `aws s3 ls` printed nothing and `list-queues` returned `"QueueUrls": []`, so both resources are gone
- Delete the local `downloaded.md`

## Tips

- Check the endpoint with a read-only command (`aws s3 ls`) before creating anything
- Use `aws <service> help` and `aws <service> <command> help` to check the arguments before running a command
- Copy the queue URL from the `create-queue` output or `list-queues` instead of rebuilding it by hand
- Before deleting a bucket, run `aws s3 ls s3://my-bucket --recursive` to see what is still inside