import argparse
import requests
import json
import urllib


def str2bool(v):
  return v.lower() in ("yes", "true", "t", "1")

def build_harvest_script():


    parser = argparse.ArgumentParser(description='CKAN Harvest sources',prog="buildharvest.py", formatter_class=lambda prog: argparse.HelpFormatter(prog,max_help_position=40))
    parser.register('type','bool',str2bool)
    parser.add_argument('-s', '--host', dest='host', default='data.noaa.gov', required=False, type=str, help='Domain name or IP address to query')
    parser.add_argument('-o', '--organization', dest='org', default='national-oceanic-and-atmospheric-administration', required=False, type=str, help='CKAN organization')
    parser.add_argument('-f', '--config_file_path', dest='config_file_path', default='/apps/ckan/etc/ckan/default/production.ini', required=False, type=str, help='CKAN server config file path')
    parser.add_argument('-v', '--verify_cert', dest='verify_cert', default=True, required=False, type='bool', help='Verify SSL certificates in requests library')
    parser.add_argument('--include_job_status', dest='include_job_status', default=True, required=False, type='bool', help='Include output from the last harvest job status in text output')
    parser.add_argument('--output_script', dest='output_script', default='harvest_source_load.sh', required=False, type=str, help='Output file name for harvest source load script')
    parser.add_argument('--output_list', dest='output_list', default='harvest_source_list.csv', required=False, type=str, help='Output file name for harvest source text dump')
    

    parsed_args = parser.parse_args()
    host = parsed_args.host
    org = parsed_args.org
    config_file_path = parsed_args.config_file_path
    verify_cert = parsed_args.verify_cert
    output_script = parsed_args.output_script
    output_list = parsed_args.output_list
    include_job_status = parsed_args.include_job_status
    
    
    url_params ="q=type:harvest AND organization:%s&rows=1000" % org
    #url_params ="q=type:harvest&rows=1000"
    
    #url_params = urllib.quote(url_params)
    url = "https://%s/api/3/action/package_search?" % (host) + url_params
    print ("url: {}").format(url)
   
    
    response = requests.get(url, verify=verify_cert)
    result = response.json()
    #print result
    
    script_out = open(output_script, 'w')
    list_out = open(output_list, 'w')
    if include_job_status: list_out.write("Name, Title, URL, Total Datasets, Job Count, Job Status, Errors, Added, Job URL, Created, Gather Started, Gather Finished, Finished \n")
    else: list_out.write("Name, Title, URL, Total Datasets \n")
    
    print result['result']['count']
    for item in result['result']['results']:
        name = item['name']
        title = item['title']
        url = item['url']
        org = item['organization']['name'];
        source_type = "waf"
        freq = "WEEKLY"
        config = "{\"private_datasets\": false}"
        for extra in item['extras']:
           if extra['key'] == "source_type":
               source_type=extra['value']
           if extra['key'] == "active":
               freq=extra['value']
           if extra['key'] == "config":
               config=extra['value']
        
        status = item['status']
        job_count = status['job_count']
        total_datasets = status['total_datasets']
        try:
            last_job = status['last_job']
            job_status = last_job['status']
            try: errors = last_job['stats']['errored'] 
            except KeyError: errors = 0
            try: added = last_job['stats']['added'] 
            except KeyError: added = 0
            created = last_job['created']
            id = last_job['id']
            finished = last_job['finished']
            gather_started = last_job['gather_started']
            gather_finished = last_job['gather_finished']
            harvest_job_url = "https://{}/harvest/{}/job/{}".format(host, name, id)
            
        except (KeyError, TypeError) as e:
            job_status = "Unknown"
            errors = 0
            added = 0
            created = "Unknown"
            id = "Unknown"
            finished = "Unknown"
            gather_started = "Unknown"
            gather_finished = "Unknown"
            harvest_job_url = "https://{}/harvest/{}".format(host, name)
        
        #install = "ckan --plugin=ckanext-harvest harvester source \"%s\" \"%s\" \"%s\" \"%s\" \"%s\" \"%s\" \"%s\" \"%s\"" % (name, url , source_type, title, "True" , org, freq, config.replace('"','\\"') )
        harvest_source_install_command = "paster --plugin=ckanext-harvest harvester source \"%s\" \"%s\" \"%s\" \"%s\" \"%s\" \"%s\" \"%s\" \"%s\" --config=%s" % (name, url , source_type, title, "True" , org, freq, config.replace('"','\\"'),  config_file_path)
        
        if include_job_status: harvest_source_list = "\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"" % (name,title,url,total_datasets,job_count,job_status,errors,added,harvest_job_url,created,gather_started,gather_finished,finished)
        else: harvest_source_list = "\"%s\",\"%s\",\"%s\",\"%s\"" % (name,title,url,total_datasets)
        
        
        
        script_out.write(harvest_source_install_command + "\n")
        list_out.write(harvest_source_list + "\n")
    
    script_out.close()
    list_out.close()
    

build_harvest_script()

