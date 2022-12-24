#!/bin/sh

echo $SNAPSHOT_CREATE_URL
echo $CUSTOM_S3_ENDPOINT
echo $CUSTOM_S3_BASEPATH

sleeptime=10m # Sleep for 10 minutes after a failed try.
maxtries=5    # 5 * 10 minutes = about 50 minutes total of waiting,
              # not counting running and failing.

while ! /vmbackup-prod -storageDataPath=/victoria-metrics-data -snapshot.createURL=$SNAPSHOT_CREATE_URL -customS3Endpoint=$CUSTOM_S3_ENDPOINT -dst=$CUSTOM_S3_BASEPATH; do
  maxtries=$(( maxtries - 1 ))
  if [ "$maxtries" -eq 0 ]; then
    echo "Victoria metrics backup didn't succeed! Exiting." >&2
    exit 1
  fi

  sleep "$sleeptime" || break
done

