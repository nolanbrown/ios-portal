require File.expand_path('../ios-portal/client', __FILE__)

module IOSPortal
  VERSION = '0.0.2'
  
  BASE_URL = "https://developer.apple.com"
  LOGIN_URL = BASE_URL + "/ios/manage/overview/index.action"
  DEVICES_URL = BASE_URL + "/ios/manage/devices/index.action"
  DEVICE_BULK_UPLOAD_URL = "/ios/manage/devices/saveupload.action"
  SAVE_TEAM_URL = BASE_URL + "/membercenter/saveTeamSelection.action"

  DEV_PROVISIONING_PROFILE_URL = BASE_URL + "/ios/manage/provisioningprofiles/index.action"
  DIST_PROVISIONING_PROFILE_URL = BASE_URL + "/ios/manage/provisioningprofiles/viewDistributionProfiles.action"

  CREATE_ADHOC_PROFILE_URL = BASE_URL + "/ios/manage/provisioningprofiles/create.action?type=2"
  DOWNLOAD_PROFILE_URL_WO_ID = BASE_URL + "/ios/manage/provisioningprofiles/download.action?blobId="
  EDIT_PROFILE_URL_WO_ID = BASE_URL + "/ios/manage/provisioningprofiles/edit.action?provDisplayId="

  SAVE_PROFILE_URL = BASE_URL + "/ios/manage/provisioningprofiles/save.action"

  def self.client(options={})
    IOSPortal::Client.new(options)
  end
  
  
end
