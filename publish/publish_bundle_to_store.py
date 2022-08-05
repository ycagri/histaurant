import argparse
import sys
from apiclient.discovery import build
import httplib2
from oauth2client import client
from oauth2client.service_account import ServiceAccountCredentials

SERVICE_ACCOUNT_EMAIL = 'histaurant-publisher@pc-api-6207277435279780652-673.iam.gserviceaccount.com'

arg_parser = argparse.ArgumentParser(add_help=False)
arg_parser.add_argument('package_name',
                        default='com.ycagri.historical_restaurants',
                        help='The package name')
arg_parser.add_argument('bundle_file',
                        nargs='?',
                        help='The path to the bundle file to upload.')
arg_parser.add_argument('track',
                        nargs='?',
                        default='alpha',
                        help='Can be alpha, beta, production or rollout')
arg_parser.add_argument('key_path',
                        nargs='?',
                        help='Path of the key file')


def create_service(key_path):
    credentials = ServiceAccountCredentials.from_p12_keyfile(
        SERVICE_ACCOUNT_EMAIL,
        key_path,
        scopes=['https://www.googleapis.com/auth/androidpublisher'])
    http = httplib2.Http()
    http = credentials.authorize(http)

    return build('androidpublisher', 'v3', http=http)


def get_edit_id(service, package_name):
    edit_request = service.edits().insert(body={}, packageName=package_name)
    result = edit_request.execute()
    return result['id']


def upload_bundle(service, edit_id, package_name, bundle_file):
    return service.edits().bundles().upload(
        editId=edit_id,
        packageName=package_name,
        media_body=bundle_file,
        media_mime_type="application/octet-stream").execute()


def update_track(service, edit_id, package_name, version_code, track):
    return service.edits().tracks().update(
        editId=edit_id,
        track=track,
        packageName=package_name,
        body={u'releases': [{
            u'name': u'Deployed by Github Action',
            u'versionCodes': [version_code],
            u'status': u'draft',
        }]}).execute()


def commit_edit(service, edit_id, package_name):
    return service.edits().commit(editId=edit_id, packageName=package_name).execute()


def publish(argv):
    # Process flags and read their values.
    flags = arg_parser.parse_args()
    package_name = flags.package_name
    bundle_file = flags.bundle_file
    track = flags.track
    key_path = flags.key_path

    service = create_service(key_path)

    try:
        edit_id = get_edit_id(service, package_name)
        bundle_response = upload_bundle(service, edit_id, package_name, bundle_file)
        print('Version code %d has been uploaded' % bundle_response['versionCode'])

        track_response = update_track(service, edit_id, package_name, str(bundle_response['versionCode']), track)
        print('Track %s is set with releases: %s' % (
            track_response['track'], str(track_response['releases'])))

        commit_request =commit_edit(service, edit_id, package_name)
        print('Edit "%s" has been committed' % (commit_request['id']))
    except client.AccessTokenRefreshError:
        print('The credentials have been revoked or expired, please re-run the '
              'application to re-authorize')


if __name__ == '__main__':
    publish(sys.argv)
