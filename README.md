Cookbook: https://banking-sandbox.starfinanz.de/ahoi/docs/cookbook/index.html
API-Explorer: https://banking-sandbox.starfinanz.de/ahoi/docs/api/swagger-ui/index.html#!/resource/Access
Sandbox-Manager: https://banking-sandbox.starfinanz.de/sandboxmanager/#/

## Some commands...

```

docker build -t nodejs-10-symbioticon .

s2i build https://github.com/cvicens/ahoi-nodejs-demo-app nodejs-10-symbioticon ahoi-nodejs-demo-app

docker run -it --rm -v $(pwd):/tmp/shared nodejs-10-symbioticon /bin/bash

```


## URLs

Your starting point is the Red Hat Solution Explorer available at: https://tutorial-web-app-webapp.symbioticon.opentry.me

You can also access the Master OpenShift console at https://symbioticon.opentry.me 

## Installing Mobile Core

First of all let's log in Openshift, then create a new project `mobile` where we'll install [Aerogear Mobile Services](https://aerogear.org/)

```shell
oc login https://symbioticon.opentry.me -u admin -p yourpass
oc new-project mobile-core
```

Now let's clone [`mobile-core`](https://github.com/aerogear/mobile-core.git) and run the installer (ansible playbook).


**Integrately**

```
oc project mobile-core
git clone https://github.com/aerogear/mobile-core.git
cd mobile-core
ansible-playbook installer/aerogear-catalog-install.yml -e "u=admin p=yourpass ansible_service_broker_namespace=openshift-ansible-service-broker"
```

**RHPDS**

```
ansible-playbook installer/aerogear-catalog-install.yml -e "u=admin -p=yourpass ansible_service_broker_namespace=openshift-ansible-service-broker"
```

## Deploy UPS

Go to project `mobile-core` and then click on `Browse Catalog`.

![Browse Catalog](./images/ag-catalog-0.png)

Open tab `Mobile`.

![Open Mobile tab](./images/ag-catalog-1.png)

Then choose `Services`.

![Choose Services](./images/ag-catalog-2.png)

Finally select 	`Push Notifications`.

![Select Push Notifications](./images/ag-catalog-3.png)

Click on `Next` twice and then on `Create`.

![Create Service](./images/ag-catalog-4.png)

Go to `Overview` to see the progress of the installation.

![Installation Progress](./images/ag-installation-1.png)

After some minutes you should get to this situation (ignore temporary errors in `ups`).

![Installation Finished](./images/ag-installation-2.png)

## Create a new Application in UPS (Unified Push Server)

Go to https://ups-mobile-core.apps.<base_domain> and click on Login with Openshift.

![Open UPS](./images/ag-ups-1.png)

Enter your credentials.

![Credentials](./images/ag-ups-2.png)

Authorize access

![Open UPS](./images/ag-ups-3.png)

Let's create a new app. Actually a new app definition from the point of view of push notifications.

![Create Application](./images/ag-ups-4.png)

Let's follow the wizzard instructions.

![Start here](./images/ag-ups-5.png)

Give your App a name.

![Name your app](./images/ag-ups-6.png)

Add a Variant. You can have as many variants as you want, different groups, different devices, etc.

![Add Variant](./images/ag-ups-7.png)

Let's create a variant for iOS, you'll need your P12 file and passphrase.

![iOS variant](./images/ag-ups-8.png)

Click on Next.

![Variant created](./images/ag-ups-9.png)

Click on 'Skip This Step'

![Open UPS](./images/ag-ups-10.png)

Congratulations!

![Open UPS](./images/ag-ups-11.png)

Now we're ready to start sending notifications with this variant.

![Open UPS](./images/ag-ups-12.png)

## Post installation steps
Before being able to use this service we need to install the CA root cert in our device.

To get the certificate installed lets first download it. Next is one way to do it using openssl...

```
openssl s_client -showcerts -verify 5 -connect ups-mobile-core.apps.<base_domain>:443 < /dev/null
```

You'll receive an answer like this.

```
CONNECTED(00000005)
depth=1 CN = openshift-signer@1542293532
verify error:num=19:self signed certificate in certificate chain
verify return:1
depth=1 CN = openshift-signer@1542293532
verify return:1
depth=0 CN = *.apps.softwareag-e07a.openshiftworkshop.com
verify return:1
---
Certificate chain
 0 s:/CN=*.apps.softwareag-e07a.openshiftworkshop.com
   i:/CN=openshift-signer@1542293532
-----BEGIN CERTIFICATE-----
MIIDdDCCAlygAwIBAgIBCTANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDDBtvcGVu
c2hpZnQtc2lnbmVyQDE1NDIyOTM1MzIwHhcNMTgxMTE1MTQ1NzUwWhcNMjAxMTE0
MTQ1NzUxWjA3MTUwMwYDVQQDDCwqLmFwcHMuc29mdHdhcmVhZy1lMDdhLm9wZW5z
aGlmdHdvcmtzaG9wLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AI8/8nuao3IJPoNkHT9IfLjTp/CXIf1HJdv6D7lPfvfsM2jz8A7LItEtVvpjiBos
zcgsLv55VF7JEgPAW4j/MqMiiAe57y2tFOcZU6ihhe9WaqhZROqiEPuuWg+L8PC0
2+Z2MiNJcKisKrfkj6x6CPZbf48gvV8n8OaX+XWNDsA8vBNYj8fWV5eB51QIY2zv
TxHobNjZ0ASQPp7XXJE6WqiMvlkymiFM4RH2NnNCp0Hgw1byqJZCy0m3vpPRb/Di
f+6bOuxrYNTw3ynWpIiktDC0IQ69GZMIvADaMR3d7YbP+dt87rW6m8XO2KTfUzBX
zKuivLzDO3pkR1WIKfyRbecCAwEAAaOBmzCBmDAOBgNVHQ8BAf8EBAMCBaAwEwYD
VR0lBAwwCgYIKwYBBQUHAwEwDAYDVR0TAQH/BAIwADBjBgNVHREEXDBagiwqLmFw
cHMuc29mdHdhcmVhZy1lMDdhLm9wZW5zaGlmdHdvcmtzaG9wLmNvbYIqYXBwcy5z
b2Z0d2FyZWFnLWUwN2Eub3BlbnNoaWZ0d29ya3Nob3AuY29tMA0GCSqGSIb3DQEB
CwUAA4IBAQCIab4TnXooi67Q1vQYDSSV4lMgr8jOMSuUpukW47i0VEBMjHGr6LU/
GFo71EYCWKtx/YqBk1EO3WXoA6VKlpBG8KTuKYod9MpBn46tpY/26lEdnTysTvFH
cdPwdp1S0c+WgDxo5qQknDYWtPLwuWnjSXhrRqM1enXK0OWUy1iPJgq4u3SO/QrB
MZxOE5+TKD63vjdNhafvz4N3XWUJ/zr6dqYeDHbSGGL86wCyzTJcPfZQoo5+eHFA
xBT3sbLfl18iCb7AWvDAKeG9ZT2mZPo9cgU8P1GOAP+QxhEWdGPYCp804aJqBo4e
iupe2xmOKv01e2ajr/9MC0yhqj8nMQv0
-----END CERTIFICATE-----
 1 s:/CN=openshift-signer@1542293532
   i:/CN=openshift-signer@1542293532
-----BEGIN CERTIFICATE-----
MIIC6jCCAdKgAwIBAgIBATANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDDBtvcGVu
c2hpZnQtc2lnbmVyQDE1NDIyOTM1MzIwHhcNMTgxMTE1MTQ1MjEyWhcNMjMxMTE0
MTQ1MjEzWjAmMSQwIgYDVQQDDBtvcGVuc2hpZnQtc2lnbmVyQDE1NDIyOTM1MzIw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCv1ldk/NUUWOKPYlzfeCho
6Mmb7f11l7LdNpLflReawyWxMoHq43NAkY9zeGaNbbq2QST1/rNpanDIDNj4TRpu
EYz+p04RmFmIY7TF5PANe66Cf98fsGoq+LtRFz5UEl/qf6vKu7mifWreXYNA3DII
oAvcBVpGUFN4cShJmrOgZkybD82GSfBuN3igyZ+QAxdrz4ftRUAt2VCzzBcNslMp
3pm3T12Amvu/+5oOTAxAxxD4OU/afaDX1AOfik+TDSP0fyfJkcqRQEXjaiv7tLeA
/vliJxmXeE6GobxzKZdC1Tc0u4aQAbND/kaipRxMLdmPHN+usEWjrCEROnm3jxzv
AgMBAAGjIzAhMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMBAf8EBTADAQH/MA0GCSqG
SIb3DQEBCwUAA4IBAQCiGfMhXqGoyNX4uZzaZyFI6lx84AIFvoP/KzjR1kE+fuBC
G9l4dUJoR8MndbEpO75Mrpf5etBWy3ynISIDEUkPpsPBlrAI6xPuhkAPHfPlD6B1
vL6bg6jwknvPxG91uGh3VjS/tf3Sl2a4t6uwkjNHIWgzNTFkdmd66vEsIWI738x5
FO/XbYFwfEDCy62gzMdN3q31EGkUsUhqZVB8JvDSGqFTeXdtS2HiirU1UNqHVX92
tNaG0e0ucFbthvOSJt1WPDQeyOUzvxoIwcPP+dfvVIHZ4u9vn+4AdQqWenzA6NTs
7C6GIal7Z4dvZKDfOwxySEMgOyY+zVjvVA+BQsbx
-----END CERTIFICATE-----
 2 s:/CN=openshift-signer@1542293532
   i:/CN=openshift-signer@1542293532
-----BEGIN CERTIFICATE-----
MIIC6jCCAdKgAwIBAgIBATANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDDBtvcGVu
c2hpZnQtc2lnbmVyQDE1NDIyOTM1MzIwHhcNMTgxMTE1MTQ1MjEyWhcNMjMxMTE0
MTQ1MjEzWjAmMSQwIgYDVQQDDBtvcGVuc2hpZnQtc2lnbmVyQDE1NDIyOTM1MzIw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCv1ldk/NUUWOKPYlzfeCho
6Mmb7f11l7LdNpLflReawyWxMoHq43NAkY9zeGaNbbq2QST1/rNpanDIDNj4TRpu
EYz+p04RmFmIY7TF5PANe66Cf98fsGoq+LtRFz5UEl/qf6vKu7mifWreXYNA3DII
oAvcBVpGUFN4cShJmrOgZkybD82GSfBuN3igyZ+QAxdrz4ftRUAt2VCzzBcNslMp
3pm3T12Amvu/+5oOTAxAxxD4OU/afaDX1AOfik+TDSP0fyfJkcqRQEXjaiv7tLeA
/vliJxmXeE6GobxzKZdC1Tc0u4aQAbND/kaipRxMLdmPHN+usEWjrCEROnm3jxzv
AgMBAAGjIzAhMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMBAf8EBTADAQH/MA0GCSqG
SIb3DQEBCwUAA4IBAQCiGfMhXqGoyNX4uZzaZyFI6lx84AIFvoP/KzjR1kE+fuBC
G9l4dUJoR8MndbEpO75Mrpf5etBWy3ynISIDEUkPpsPBlrAI6xPuhkAPHfPlD6B1
vL6bg6jwknvPxG91uGh3VjS/tf3Sl2a4t6uwkjNHIWgzNTFkdmd66vEsIWI738x5
FO/XbYFwfEDCy62gzMdN3q31EGkUsUhqZVB8JvDSGqFTeXdtS2HiirU1UNqHVX92
tNaG0e0ucFbthvOSJt1WPDQeyOUzvxoIwcPP+dfvVIHZ4u9vn+4AdQqWenzA6NTs
7C6GIal7Z4dvZKDfOwxySEMgOyY+zVjvVA+BQsbx
-----END CERTIFICATE-----
---
Server certificate
subject=/CN=*.apps.softwareag-e07a.openshiftworkshop.com
issuer=/CN=openshift-signer@1542293532
---
No client certificate CA names sent
---
SSL handshake has read 3048 bytes and written 444 bytes
---
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES128-GCM-SHA256
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256
    Session-ID: 524AFB4010D548E3EA045E889EC2D10A811E5A29AB76FD992E9FF4CCD27894EF
    Session-ID-ctx: 
    Master-Key: DAAEB54EF1D5A6DD0C0155950F1E6A318B6835E1C30B744679F003DC3E2EFCAC47C2F2CB7E8F4A8A21846D0C491C226A
    TLS session ticket lifetime hint: 300 (seconds)
    TLS session ticket:
    0000 - 5f 08 21 b0 75 87 f8 61-c5 54 a0 e7 20 d8 84 32   _.!.u..a.T.. ..2
    0010 - b5 ab ff ad 53 01 3a 43-ed 18 e6 35 c2 0d 2f 79   ....S.:C...5../y
    0020 - 3d ae 68 8d 3e 0e f5 99-82 2e 3e f8 77 96 00 a4   =.h.>.....>.w...
    0030 - 02 bd b4 df 59 02 2f 1b-7c cc 70 55 e5 23 79 65   ....Y./.|.pU.#ye
    0040 - 92 71 cf 15 b6 02 47 72-f1 9e 9e 50 1a fe 7c 1a   .q....Gr...P..|.
    0050 - b1 44 0e ae 45 73 a1 54-82 e0 7e 4b 5c 26 91 fe   .D..Es.T..~K\&..
    0060 - 18 a2 79 6e 60 d7 dd b8-22 5e 92 75 f8 11 26 44   ..yn`..."^.u..&D
    0070 - c6 58 42 6b 5f c3 79 f7-27 e6 ec 40 4a dd 5f 52   .XBk_.y.'..@J._R
    0080 - 50 01 1e a9 d9 0d 11 6e-07 83 2c e9 8c 31 ad 34   P......n..,..1.4
    0090 - 7b 23 19 8b 62 45 1a 28-fe 78 af 5c 0b dd b3 c6   {#..bE.(.x.\....

    Start Time: 1542368084
    Timeout   : 300 (sec)
    Verify return code: 19 (self signed certificate in certificate chain)
---
```

Copy and paste entry `2` designated as ` 2 s:/CN=openshift-signer@1542293532` from `-----BEGIN CERTIFICATE-----` to `-----END CERTIFICATE-----` in a file, for instance `openshift-signer.cer`

```
-----BEGIN CERTIFICATE-----
MIIC6jCCAdKgAwIBAgIBATANBgkqhkiG9w0BAQsFADAmMSQwIgYDVQQDDBtvcGVu
c2hpZnQtc2lnbmVyQDE1NDIyOTM1MzIwHhcNMTgxMTE1MTQ1MjEyWhcNMjMxMTE0
MTQ1MjEzWjAmMSQwIgYDVQQDDBtvcGVuc2hpZnQtc2lnbmVyQDE1NDIyOTM1MzIw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCv1ldk/NUUWOKPYlzfeCho
6Mmb7f11l7LdNpLflReawyWxMoHq43NAkY9zeGaNbbq2QST1/rNpanDIDNj4TRpu
EYz+p04RmFmIY7TF5PANe66Cf98fsGoq+LtRFz5UEl/qf6vKu7mifWreXYNA3DII
oAvcBVpGUFN4cShJmrOgZkybD82GSfBuN3igyZ+QAxdrz4ftRUAt2VCzzBcNslMp
3pm3T12Amvu/+5oOTAxAxxD4OU/afaDX1AOfik+TDSP0fyfJkcqRQEXjaiv7tLeA
/vliJxmXeE6GobxzKZdC1Tc0u4aQAbND/kaipRxMLdmPHN+usEWjrCEROnm3jxzv
AgMBAAGjIzAhMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMBAf8EBTADAQH/MA0GCSqG
SIb3DQEBCwUAA4IBAQCiGfMhXqGoyNX4uZzaZyFI6lx84AIFvoP/KzjR1kE+fuBC
G9l4dUJoR8MndbEpO75Mrpf5etBWy3ynISIDEUkPpsPBlrAI6xPuhkAPHfPlD6B1
vL6bg6jwknvPxG91uGh3VjS/tf3Sl2a4t6uwkjNHIWgzNTFkdmd66vEsIWI738x5
FO/XbYFwfEDCy62gzMdN3q31EGkUsUhqZVB8JvDSGqFTeXdtS2HiirU1UNqHVX92
tNaG0e0ucFbthvOSJt1WPDQeyOUzvxoIwcPP+dfvVIHZ4u9vn+4AdQqWenzA6NTs
7C6GIal7Z4dvZKDfOwxySEMgOyY+zVjvVA+BQsbx
-----END CERTIFICATE-----
```

Now send this file to your device. If your device is iOS and you have a macOS AirDrop is the easiest way.

Once you air-drop the certificate, accept in your device and follow these instructions.

![Install certificate](./images/ios-cert-1.PNG)
![Install certificate](./images/ios-cert-2.PNG)
![Install certificate](./images/ios-cert-3.PNG)
![Install certificate](./images/ios-cert-4.PNG)
![Install certificate](./images/ios-cert-5.PNG)
![Install certificate](./images/ios-cert-6.PNG)
![Install certificate](./images/ios-cert-7.PNG)

## Create your push notifications certificate [iOS]

For instance you can follow [this](https://www.raywenderlich.com/584-push-notifications-tutorial-getting-started) guide to create your certificate.

## Running the sample App




If everything goes as planned you should get messages similar to these ones.

```
Permission granted: true
Device Token: 207f913b5f14dff2345234526fc58416fc5b00a61a1c0a3408cab56c2e5e024e0785
2018-11-16 12:43:00.292 [Info] > PushTest Version: 1.0 Build: 1 PID: 10832
2018-11-16 12:43:00.292 [Info] > XCGLogger Version: 6.1.0 - Level: Debug
2018-11-16 12:43:00.297 [Info] [AppDelegate.swift:76] application(_:didRegisterForRemoteNotificationsWithDeviceToken:) > Registered for notifications with token
2018-11-16 12:43:00.298 [Debug] [AgsCore.swift:16] init() > Initializing AeroGearServices Core SDK
2018-11-16 12:43:00.298 [Debug] [ConfigParser.swift:12] readLocalJsonData > Parsing configuration mobile-services
2018-11-16 12:43:00.302 [Debug] [MetricsNetworkPublisher.swift:17] publish > Sending metrics ["timestamp": 1542368580301, "type": "init", "clientId": Optional("5AFFBB86-57ED-4A62-B8DF-D0F0880C1FA8"), "data": ["app": ["sdkVersion": Optional("2.0.0"), "appVersion": Optional("1.0"), "framework": Optional("native"), "appId": Optional("com.symbioticon.PushTest")], "device": ["platformVersion": "11.3", "device": "iPhone", "platform": "ios"]]]
2018-11-16 12:43:00.687 [Info] [AppDelegate.swift:102] registerPushService > Successfully registered to Unified Push Server

```




+++++++++++++++++++++++++++++++++++++ notes...


Install mobile-developer-console

oc login ...
oc project mobile

git clone https://github.com/aerogear/mobile-developer-console
cd mobile-developer-console
export ASB_PROJECT_NAME="openshift-ansible-service-broker”
./scripts/post_install.sh 


oc policy add-role-to-user view system:serviceaccount:mobile:mobile-developer-console -n mobile

oc policy add-role-to-user edit system:serviceaccount:mobile:mobile-developer-console -n mobile
