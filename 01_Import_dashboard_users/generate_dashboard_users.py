#!/usr/bin/env python3

import sys
import os
import requests
import dateutil.parser

s = requests.Session()
s.headers.update({'User-Agent': "Urbanecm's analytics script (urbanecm@tools.wmflabs.org)"})

if len(sys.argv) >= 2:
	tmpdir = sys.argv[1]
else:
	tmpdir = "/home/urbanecm/tmp"

def format_row(row):
	return "\t".join([str(x) for x in row])

def normalize_campaign(campaign):
	if campaign == 'wikimedia_čr__studenti_archiv':
		return 'studenti'
	elif campaign == 'wikimedia_čr__knihovny_archiv':
		return 'knihovny'
	elif campaign == 'wikimedia_čr__učitelé':
		return 'ucitele'
	elif campaign == 'wikimedia_čr__senioři_všichni':
		return 'seniori'
	else:
		return campaign

campaigns = ['studenti', 'wikimedia_čr__studenti_archiv', 'workshopy', 'knihovny', 'wikimedia_čr__knihovny_archiv', 'seniori', 'wikimedia_čr__senioři_všichni', 'wikimedia_čr__učitelé']

coursesWritten = []
coursesFile = open(os.path.join(tmpdir, 'courses.tsv'), 'w')
coursesUsersFile = open(os.path.join(tmpdir, 'coursesUsers.tsv'), 'w')
for campaign_raw in campaigns:
	r = s.get("https://outreachdashboard.wmflabs.org/campaigns/%s/users.json" % campaign_raw)
	campaign = normalize_campaign(campaign_raw)
	data = r.json()
	for user in data.get('users', []):
		if user['course'] not in coursesWritten:
			r = s.get('https://outreachdashboard.wmflabs.org/courses/%s/course.json' % user['course'])
			courseData = r.json().get('course', {})
			wikis = []
			for wiki in courseData['wikis']:
				project = wiki['project'].replace('wikipedia', 'wiki')
				if project == 'wikidata':
					wikis.append('wikidatawiki')
				elif wiki['language'] == 'commons' and project == 'wikimedia':
					wikis.append('commonswiki')
				elif wiki['language'] is None and project == 'wikisource':
					wikis.append('sourceswiki')
				else:
					if wiki['language'] is None:
						print(wiki)
					wikis.append(wiki['language'] + project)
			wikis.sort()
			coursesFile.write(format_row([
				campaign,
				user['course'], 
				dateutil.parser.isoparse(courseData['start']).strftime('%Y-%m-%d'),
				dateutil.parser.isoparse(courseData['end']).strftime('%Y-%m-%d'),
				"|".join(wikis)
			]) + "\n")
			coursesWritten.append(user['course'])
		coursesUsersFile.write(format_row([
			campaign,
			user['course'],
			user['role'].lower(),
			user['username']
		]) + "\n")
