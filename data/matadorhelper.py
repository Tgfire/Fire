#!/usr/bin/python
# -*- coding: utf-8 -*-
import telebot
import demjson
from telebot import util,types
import sys
import glob
import json
import redis
import os
import re
import time
from time import sleep
import logging
import subprocess
import requests
import random
from random import randint
import urllib
from urllib import urlretrieve as dw
import urllib2
import io
reload(sys)
sys.setdefaultencoding("utf-8")


token = "381363835:AAEDv-NQZMf8BuUZn3RPzGcnol4q9k-oklU"
bot = telebot.TeleBot(token)
redis = redis.StrictRedis(host='localhost', port=6379, db=0)
sudo = '285878103'
dos = 'moderation.json'

f = "\n \033[01;30m Bot Firstname: {} \033[0m".format(bot.get_me().first_name)
u = "\n \033[01;34m Bot Username: {} \033[0m".format(bot.get_me().username)
i = "\n \033[01;32m Bot ID: {} \033[0m".format(bot.get_me().id)
c = "\n \033[01;31m Bot Is Online Now! \033[0m"
print(f + u + i + c)


def load_data(filename):
	f = open(filename)
	if not f:
		return
	s = f.read()
	data = demjson.decode(s)
	return data

def save_data(filename, data):
	s = demjson.encode(data)
	f = open(filename, 'w')
	f.write(s)
	f.close()

def link(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_link"] == "lock":
			return "✅"
		else:
			return "❌"

def lockall(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_all"] == "lock":
			return "✅"
		else:
			return "❌"

def lockall(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_username"] == "lock":
			return "✅"
		else:
			return "❌"			

def lockall(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_english"] == "lock":
			return "✅"
		else:
			return "❌"
			
def tag(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_tag"] == "lock":
			return "✅"
		else:
			return "❌"

def spam(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_spam"] == "lock":
			return "✅"
		else:
			return "❌"

def markdown(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_markdown"] == "lock":
			return "✅"
		else:
			return "❌"

def webpage(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_webpage"] == "lock":
			return "✅"
		else:
			return "❌"

def bots(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_bots"] == "lock":
			return "✅"
		else:
			return "❌"

def flood(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_flood"] == "lock":
			return "✅"
		else:
			return "❌"

def mention(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_mention"] == "lock":
			return "✅"
		else:
			return "❌"

def join(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_join"] == "lock":
			return "✅"
		else:
			return "❌"

def arabic(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_arabic"] == "lock":
			return "✅"
		else:
			return "❌"

def edit(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_edit"] == "lock":
			return "✅"
		else:
			return "❌"

def gpwelcome(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["welcome"] == "yes":
			return "✅"
		else:
			return "❌"

def pin(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["settings"]["lock_pin"] == "lock":
			return "✅"
		else:
			return "❌"

def audio(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_audio"] == "mute":
			return "🔇"
		else:
			return "🔉"

def game(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_game"] == "mute":
			return "🔇"
		else:
			return "🔉"

def gptext(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_text"] == "mute":
			return "🔇"
		else:
			return "🔉"

def gpinline(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_inline"] == "mute":
			return "🔇"
		else:
			return "🔉"

def tgservice(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_tgservice"] == "mute":
			return "🔇"
		else:
			return "🔉"

def voice(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_voice"] == "mute":
			return "🔇"
		else:
			return "🔉"

def sticker(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_sticker"] == "mute":
			return "🔇"
		else:
			return "🔉"

def contact(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_contact"] == "mute":
			return "🔇"
		else:
			return "🔉"

def document(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_doc"] == "mute":
			return "🔇"
		else:
			return "🔉"

def forward(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_fwd"] == "mute":
			return "🔇"
		else:
			return "🔉"

def location(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_loc"] == "mute":
			return "🔇"
		else:
			return "🔉"

def gif(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_gif"] == "mute":
			return "🔇"
		else:
			return "🔉"

def photo(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_photos"] == "mute":
			return "🔇"
		else:
			return "🔉"

def video(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_video"] == "mute":
			return "🔇"
		else:
			return "🔉"

def all(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_all"] == "mute":
			return "🔇"
		else:
			return "🔉"

def keyboard(call):
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
		if data[str(target)]["mutes"]["mute_keyboard"] == "mute":
			return "🔇"
		else:
			return "🔉"


@bot.callback_query_handler(func=lambda call: True)
def inline(call):
    try:
	if call.data:
		target = '-' + str(call.data.split('-')[1])
		data = load_data('moderation.json')
	        lock_link = data[str(target)]["settings"]["lock_link"]
	        lock_tag = data[str(target)]["settings"]["lock_tag"]
		lock_username = data[str(target)]["settings"]["lock_username"]
	        lock_spam = data[str(target)]["settings"]["lock_spam"]
	        lock_webpage = data[str(target)]["settings"]["lock_webpage"]
	        lock_markdown = data[str(target)]["settings"]["lock_markdown"]
	        lock_bots = data[str(target)]["settings"]["lock_bots"]
		lock_flood = data[str(target)]["settings"]["lock_flood"]
	        lock_join = data[str(target)]["settings"]["lock_join"]
	        lock_mention = data[str(target)]["settings"]["lock_mention"]
        	lock_arabic = data[str(target)]["settings"]["lock_arabic"]
	        lock_english = data[str(target)]["settings"]["lock_english"]
	        lock_edit = data[str(target)]["settings"]["lock_edit"]
	        lock_all = data[str(target)]["settings"]["lock_all"]
	        flood_char = data[str(target)]["settings"]["set_char"]
	        flood_time = data[str(target)]["settings"]["time_check"]
	        welcome = data[str(target)]["settings"]["welcome"]
	        gpname = data[str(target)]["settings"]["set_name"]
	        gplink = data[str(target)]["settings"]["linkgp"]
	        gprules = data[str(target)]["rules"]
	        lock_pin = data[str(target)]["settings"]["lock_pin"]
		max_flood = data[str(target)]["settings"]["num_msg_max"]
		mute_audio = data[str(target)]["mutes"]["mute_audio"]
		mute_game = data[str(target)]["mutes"]["mute_game"]
	        mute_text = data[str(target)]["mutes"]["mute_text"]
		mute_inline = data[str(target)]["mutes"]["mute_inline"]
		mute_tgservice = data[str(target)]["mutes"]["mute_tgservice"]
	        mute_voice = data[str(target)]["mutes"]["mute_voice"]
		mute_sticker = data[str(target)]["mutes"]["mute_sticker"]
		mute_contact = data[str(target)]["mutes"]["mute_contact"]
		mute_document = data[str(target)]["mutes"]["mute_doc"]
	        mute_forward = data[str(target)]["mutes"]["mute_fwd"]
	        mute_gif = data[str(target)]["mutes"]["mute_gif"]
	        mute_location = data[str(target)]["mutes"]["mute_loc"]
		mute_photo = data[str(target)]["mutes"]["mute_photos"]
		mute_video = data[str(target)]["mutes"]["mute_video"]
		mute_all = data[str(target)]["mutes"]["mute_all"]
		mute_keyboard = data[str(target)]["mutes"]["mute_keyboard"]
		owner = data[str(target)]["owners"]
		mods = data[str(target)]["mods"]
		lang = redis.get("gp_lang:"+str(target))
		if str(call.from_user.id) in mods or str(call.from_user.id) in owner:
			if call.data == "settings"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Lock Link", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(link(call)), callback_data='lock_link'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Tag", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(tag(call)), callback_data='lock_tag'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock username", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(tag(call)), callback_data='lock_username'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Spam", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(spam(call)), callback_data='lock_spam'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Webpage", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(webpage(call)), callback_data='lock_webpage'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Markdown", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(markdown(call)), callback_data='lock_markdown'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Join", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(join(call)), callback_data='lock_join'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Flood", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(flood(call)), callback_data='lock_flood'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Mention", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(mention(call)), callback_data='lock_mention'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Arabic", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(arabic(call)), callback_data='lock_arabic'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock English", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(arabic(call)), callback_data='lock_english'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock Edit", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(edit(call)), callback_data='lock_edit'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Bots Protection", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(bots(call)), callback_data='lock_bots'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Lock All", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(lockall(call)), callback_data='lock_all'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Flood Sensitivity", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(max_flood), callback_data='max_flood'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Character Sensitivity", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(flood_char), callback_data='flood_char'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Flood Check Time", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(flood_time), callback_data='flood_time'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Group Welcome", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(gpwelcome(call)), callback_data='welcome'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Back", callback_data='option'+str(target))
					b = types.InlineKeyboardButton("Next ", callback_data='mutelist'+str(target))
				        markup.add(a, b)
					bot.edit_message_text("*Group Settings :*",inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				elif lang:
                                        markup = types.InlineKeyboardMarkup()
                                        a = types.InlineKeyboardButton("قفل لينک", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(link(call)), callback_data='lock_link'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل تگ", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(tag(call)), callback_data='lock_tag'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل نام کاربری", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(tag(call)), callback_data='lock_username'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل هرزنامه", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(spam(call)), callback_data='lock_spam'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل صفحات وب", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(webpage(call)), callback_data='lock_webpage'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("قفل فونت", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(markdown(call)), callback_data='lock_markdown'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل ورود اعضا", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(join(call)), callback_data='lock_join'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("قفل پيام مکرر", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(flood(call)), callback_data='lock_flood'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل فراخواني", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(mention(call)), callback_data='lock_mention'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل عربي", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(arabic(call)), callback_data='lock_arabic'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل انگلیسی", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(arabic(call)), callback_data='lock_english'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("قفل ويرايش پيام", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(edit(call)), callback_data='lock_edit'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("محافظت در برابر ربات ها", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(bots(call)), callback_data='lock_bots'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("قفل همه", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(lockall(call)), callback_data='lock_all'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("حداکثر پيام مکرر", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(max_flood), callback_data='max_flood'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("حداکثر حروف مجاز", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(flood_char), callback_data='flood_char'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("زمان بررسي پيام هاي مکرر", callback_data='1')
  					b = types.InlineKeyboardButton("{}".format(flood_time), callback_data='flood_time'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("پيام خوشامد گويي", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(gpwelcome(call)), callback_data='welcome'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("بازگشت", callback_data='option'+str(target))
	                                b = types.InlineKeyboardButton("بعدی", callback_data='mutelist'+str(target))
                                        markup.add(a, b)
					bot.edit_message_text("`تنظيمات گروه :`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "mutelist"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Mute Audio", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(audio(call)), callback_data='mute_audio'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Text", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(gptext(call)), callback_data='mute_text'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Inline", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(gpinline(call)), callback_data='mute_inline'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Game", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(game(call)), callback_data='mute_game'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute TgService", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(tgservice(call)), callback_data='mute_tgservice'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Voice", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(voice(call)), callback_data='mute_voice'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Sticker", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(sticker(call)), callback_data='mute_sticker'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Contact", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(contact(call)), callback_data='mute_contact'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Document", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(document(call)), callback_data='mute_document'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Forward", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(forward(call)), callback_data='mute_forward'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Gif", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(gif(call)), callback_data='mute_gif'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Location", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(location(call)), callback_data='mute_location'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Photo", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(photo(call)), callback_data='mute_photo'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute Video", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(video(call)), callback_data='mute_video'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute All", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(all(call)), callback_data='mute_all'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Mute KeyBoard", callback_data='1')  
					b = types.InlineKeyboardButton("{}".format(keyboard(call)), callback_data='mute_keyboard'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("Back", callback_data='settings'+str(target))
                                        markup.add(a)
					bot.edit_message_text("*Group Mutelist :*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
                                        markup = types.InlineKeyboardMarkup()
                                        a = types.InlineKeyboardButton("بيصدا آهنگ", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(audio(call)), callback_data='mute_audio'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا متن", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(gptext(call)), callback_data='mute_text'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا کيبورد شيشه اي", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(gpinline(call)), callback_data='mute_inline'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("بيصدا بازي هاي تحت وب", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(game(call)), callback_data='mute_game'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("بيصدا خدمات تلگرام", callback_data='1') 
					b = types.InlineKeyboardButton("{}".format(tgservice(call)), callback_data='mute_tgservice'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا صدا", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(voice(call)), callback_data='mute_voice'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("بيصدا برچسب", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(sticker(call)), callback_data='mute_sticker'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("بيصدا مخاطب", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(contact(call)), callback_data='mute_contact'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا فايل", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(document(call)), callback_data='mute_document'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("بيصدا نقل قول", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(forward(call)), callback_data='mute_forward'+str(target))
					markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا تصاوير متحرک", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(gif(call)), callback_data='mute_gif'+str(target))
                                        markup.add(a, b)
					a = types.InlineKeyboardButton("بيصدا موقعيت مکاني", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(location(call)), callback_data='mute_location'+str(target))
					markup.add(a, b)
					a = types.InlineKeyboardButton("بيصدا عکس", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(photo(call)), callback_data='mute_photo'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا فيلم", callback_data='1')
					b = types.InlineKeyboardButton("{}".format(video(call)), callback_data='mute_video'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا همه پيام ها", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(all(call)), callback_data='mute_all'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بيصدا صفحه کليد", callback_data='1')
                                        b = types.InlineKeyboardButton("{}".format(keyboard(call)), callback_data='mute_keyboard'+str(target))
                                        markup.add(a, b)
                                        a = types.InlineKeyboardButton("بازگشت", callback_data='settings'+str(target))
                                        markup.add(a)
                                        bot.edit_message_text("`ليست بيصداهاي گروه :`", inline_message_id = call.inline_message_id,reply_markup=markup, parse_mode='Markdown')

			if call.data == "langen"+str(target):
				redis.delete("gp_lang:"+str(target))
                                markup = types.InlineKeyboardMarkup()
				a = types.InlineKeyboardButton("Back", callback_data='option'+str(target))
				markup.add(a)
				bot.edit_message_text("*Group Language Set To : EN*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "langfa"+str(target):
				redis.set("gp_lang:"+str(target), True)
                                markup = types.InlineKeyboardMarkup()
				a = types.InlineKeyboardButton("Back", callback_data='option'+str(target))
				markup.add(a)
				bot.edit_message_text("`زبان گروه تنظیم شد به : فارسی`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "language"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
                                        a = types.InlineKeyboardButton("🇬🇧 English 🇬🇧", callback_data='langen'+str(target))
                                        b = types.InlineKeyboardButton("🇮🇷 Persian 🇮🇷", callback_data='langfa'+str(target))
                                        markup.add(a,b)
                                        a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
                                        markup.add(a)
					bot.edit_message_text("*Please Select Your Language :*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					markup = types.InlineKeyboardMarkup()
                                        a = types.InlineKeyboardButton("🇬🇧 انگلیسی 🇬🇧", callback_data='langen'+str(target))
                                        b = types.InlineKeyboardButton("🇮🇷 فارسی 🇮🇷", callback_data='langfa'+str(target))
                                        markup.add(a,b)
                                        a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
                                        markup.add(a)
					bot.edit_message_text("`لطفا زبان مورد نظر را انتخاب کنید :`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "max_flood"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton("Back", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("*Group Flood : {}*".format(max_flood), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton("بازگشت", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("`حداکثر پيام مکرر گروه : {}`".format(max_flood), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "kamflood"+str(target):
				if not lang:
					if max_flood == 1:
						markup = types.InlineKeyboardMarkup()
                                                s = types.InlineKeyboardButton("❌", callback_data='errorflood'+str(target))
                                                d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
                                                markup.add(s,d)
                                                a = types.InlineKeyboardButton("Back", callback_data='settings'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Group Flood : 1*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["num_msg_max"] = int(max_flood) - 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Group Flood : {}*".format(int(max_flood) - 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if max_flood == 1:
						markup = types.InlineKeyboardMarkup()
                                                s = types.InlineKeyboardButton("❌", callback_data='errorflood'+str(target))
                                                d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
                                                markup.add(s,d)
                                                a = types.InlineKeyboardButton("بازگشت", callback_data='settings'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`حداکثر پیام مکرر گروه : 1`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["num_msg_max"] = int(max_flood) - 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`حداکثر پيام مکرر گروه : {}`".format(int(max_flood) - 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "ziadflood"+str(target):
				if not lang:
					if max_flood == 50:
						markup = types.InlineKeyboardMarkup()
                                                s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
                                                d = types.InlineKeyboardButton("❌", callback_data='errorflood'+str(target))
                                                markup.add(s,d)
                                                a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Group Flood : 50*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["num_msg_max"] = int(max_flood) + 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Group Flood : {}*".format(int(max_flood) + 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if max_flood == 50:
						markup = types.InlineKeyboardMarkup()
                                                s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
                                                d = types.InlineKeyboardButton("❌", callback_data='errorflood'+str(target))
                                                markup.add(s,d)
                                                a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`حداکثر پیام مکرر گروه : 50`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["num_msg_max"] = int(max_flood) + 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamflood'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadflood'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`حداکثر پيام مکرر گروه : {}`".format(int(max_flood) + 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "errorflood"+str(target):
				if not lang:
					if max_flood == 1:
						markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton(" Back", callback_data='kamflood'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Flood Sensestivity Is [1-50]\nPlease Plus It!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					elif max_flood == 50:
                                                markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton(" Back", callback_data='ziadflood'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Flood Sensestivity Is [1-50]\nPlease Negative It!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					if max_flood == 1:
                                                markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton("بازگشت", callback_data='kamflood'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`حداکثر پیام مکرر [۱-۵۰] میباشد\nلطفا آنرا افزایش دهید!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					elif max_flood == 50:
                                                markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton(" بازگشت", callback_data='ziadflood'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`حداکثر پیام مکرر [۱-۵۰] میباشد\nلطفا آنرا کاهش دهید!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "flood_char"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamchar'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadchar'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("*Group Flood Character : {}*".format(flood_char), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamchar'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadchar'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("`حداکثر حروف مجاز گروه : {}`".format(flood_char), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "kamchar"+str(target):
				if not lang:
					data[str(target)]["settings"]["set_char"] = int(flood_char) - 1
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamchar'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadchar'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("*Group Flood Character : {}*".format(int(flood_char) - 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					data[str(target)]["settings"]["set_char"] = int(flood_char) - 1
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamchar'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadchar'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("`حداکثر حروف مجاز گروه : {}`".format(int(flood_char) - 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "ziadchar"+str(target):
				if not lang:
					data[str(target)]["settings"]["set_char"] = int(flood_char) + 1
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamchar'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadchar'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("*Group Flood Character : {}*".format(int(flood_char) + 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					data[str(target)]["settings"]["set_char"] = int(flood_char) + 1
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamchar'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadchar'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("`حداکثر حروف مجاز گروه : {}`".format(int(flood_char) + 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "flood_time"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("*Group Flood Check Time : {}*".format(flood_time), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
					d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
					markup.add(s,d)
					a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
					markup.add(a)
					bot.edit_message_text("`زمان بررسي پيام هاي مکرر : {}`".format(flood_time), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "kamtime"+str(target):
				if not lang:
					if flood_time == 1:
                                                markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("❌", callback_data='errortime'+str(target))
                                                d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
						markup.add(s,d)
                                                a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
                                                markup.add(a)
						bot.edit_message_text("*Group Flood Check Time : 1*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["time_check"] = int(flood_time) - 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Group Flood Check Time : {}*".format(int(flood_time) - 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if flood_time == 1:
                                                markup = types.InlineKeyboardMarkup()
                                                s = types.InlineKeyboardButton("❌", callback_data='errortime'+str(target))
                                                d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
                                                markup.add(s,d)
                                                a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
                                                markup.add(a)
						bot.edit_message_text("`زمان بررسی پیام های مکرر : 1`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["time_check"] = int(flood_time) - 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`زمان بررسي پيام هاي مکرر : {}`".format(int(flood_time) - 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "ziadtime"+str(target):
				if not lang:
					if flood_time == 10:
                                                markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
                                                d = types.InlineKeyboardButton("❌", callback_data='errortime'+str(target))
                                                markup.add(s,d)
                                                a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
                                                markup.add(a)
						bot.edit_message_text("*Group Flood Check Time : 10*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["time_check"] = int(flood_time) + 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Group Flood Check Time : {}*".format(int(flood_time) + 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if flood_time == 10:
                                                markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
                                                d = types.InlineKeyboardButton("❌", callback_data='errortime'+str(target))
                                                markup.add(s,d)
                                                a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
                                                markup.add(a)
						bot.edit_message_text("`زمان بررسی پیام های مکرر : ۱۰`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["time_check"] = int(flood_time) + 1
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						s = types.InlineKeyboardButton("⏪", callback_data='kamtime'+str(target))
						d = types.InlineKeyboardButton("⏩", callback_data='ziadtime'+str(target))
						markup.add(s,d)
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`زمان بررسي پيام هاي مکرر : {}`".format(int(flood_time) + 1), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "errortime"+str(target):
				if not lang:
					if flood_time == 1:
						markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton(" Back", callback_data='kamtime'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Group Flood Check Time Is [1-10]\nPlease Plus It!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					elif max_flood == 10:
                                                markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton(" Back", callback_data='ziadtime'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Group Flood Check Time Is [1-10]\nPlease Negative It!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					if flood_time == 1:
                                                markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton(" بازگشت", callback_data='kamtime'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`زمان بررسی پیام های مکرر [۱-۱۰] میباشد\nلطفا آنرا افزایش دهید!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					elif max_flood == 10:
                                                markup = types.InlineKeyboardMarkup()
                                                a = types.InlineKeyboardButton(" بازگشت", callback_data='ziadtime'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`زمان بررسی پیام های مکرر [۱-۱۰] میباشد\nلطفا آنرا کاهش دهید!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "option"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Group Language", callback_data='language'+str(target))
				        markup.add(a)
					a = types.InlineKeyboardButton("About", callback_data='about'+str(target))
					b = types.InlineKeyboardButton("Group Expire Date", callback_data='expire'+str(target))
					markup.add(a,b)
					a = types.InlineKeyboardButton("Group Rules", callback_data='rules'+str(target))
					b = types.InlineKeyboardButton("Group Link", callback_data='gplink'+str(target))
					markup.add(a,b)
					c = types.InlineKeyboardButton("Banlist", callback_data='banlist'+str(target))
					g = types.InlineKeyboardButton("SilentList", callback_data='silentlist'+str(target))
					markup.add(c,g)
					h = types.InlineKeyboardButton("Filterlist", callback_data='filterlist'+str(target))
					j = types.InlineKeyboardButton("Whitelist", callback_data='whitelist'+str(target))
					markup.add(h,j)
					o = types.InlineKeyboardButton("Ownerlist", callback_data='ownerlist'+str(target))
					u = types.InlineKeyboardButton("Modlist", callback_data='modlist'+str(target))
					markup.add(o,u)
					k = types.InlineKeyboardButton("Settings", callback_data='settings'+str(target))
					markup.add(k)
					a = types.InlineKeyboardButton("Fun Tools", callback_data='funtools'+str(target))
					markup.add(a)
					bot.edit_message_text("*Welcome To Group Option!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("زبان گروه", callback_data='language'+str(target))
				        markup.add(a)
					a = types.InlineKeyboardButton("درباره ربات", callback_data='about'+str(target))
					b = types.InlineKeyboardButton("تاریخ انقضای گروه", callback_data='expire'+str(target))
					markup.add(a,b)
					a = types.InlineKeyboardButton("قوانین گروه", callback_data='rules'+str(target))
					b = types.InlineKeyboardButton("لینک گروه", callback_data='gplink'+str(target))
					markup.add(a,b)
					c = types.InlineKeyboardButton("ليست سياه", callback_data='banlist'+str(target))
					g = types.InlineKeyboardButton("ليست کاربران سايلنت شده", callback_data='silentlist'+str(target))
					markup.add(c,g)
					h = types.InlineKeyboardButton("ليست کلمات فيلتر شده", callback_data='filterlist'+str(target))
					j = types.InlineKeyboardButton("ليست سفيد", callback_data='whitelist'+str(target))
					markup.add(h,j)
					o = types.InlineKeyboardButton("ليست مالکان", callback_data='ownerlist'+str(target))
					u = types.InlineKeyboardButton("ليست مديران", callback_data='modlist'+str(target))
					markup.add(o,u)
					k = types.InlineKeyboardButton("تنظيمات", callback_data='settings'+str(target))
					markup.add(k)
					a = types.InlineKeyboardButton("ابزار سرگرمی", callback_data='funtools'+str(target))
					markup.add(a)
                                        bot.edit_message_text("`به تنظيمات گروه خوش آمديد!`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "funtools"+str(target):
				if not lang:
                                        markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Date And Time", callback_data='timedate'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("Fal", callback_data='fal'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("Day Mention", callback_data='zekr'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("Hadith", callback_data='hadis'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("Do You Know?", callback_data='danestani'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("Back", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("*Welcome To Group Fun Tools!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
                                        markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("تاریخ و ساعت", callback_data='timedate'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("فال", callback_data='fal'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("ذکر روز", callback_data='zekr'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("حدیث", callback_data='hadis'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("دانستنی", callback_data='danestani'+str(target))
					markup.add(a)
					a = types.InlineKeyboardButton("بازگشت", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("`به بخش ابزار سرگرمی گروه خوش آمدید!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "timedate"+str(target):
				if not lang:
					reqa = urllib2.Request('http://irapi.ir/time/')
					openera = urllib2.build_opener()
					fa = openera.open(reqa)
					parsed_jsona = json.loads(fa.read())
					ENtime = parsed_jsona['ENtime']
					ENdate = parsed_jsona['ENdate']
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("Reload", callback_data='timedate'+str(target))
					a = types.InlineKeyboardButton(" Back", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("*Today : {}\n\nTime : {}*".format(ENdate,ENtime), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					reqa = urllib2.Request('http://irapi.ir/time/')
					openera = urllib2.build_opener()
					fa = openera.open(reqa)
					parsed_jsona = json.loads(fa.read())
					FAtime = parsed_jsona['FAtime']
					FAdate = parsed_jsona['FAdate']
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("بازگذاری مجدد", callback_data='timedate'+str(target))
					a = types.InlineKeyboardButton(" بازگشت", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`امروز : {}\n\nساعت : {}`".format(FAdate,FAtime), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "zekr"+str(target):
				if not lang:
					res = urllib.urlopen("http://api.hektor-tm.ir/zekr/").read()
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("Reload", callback_data='zekr'+str(target))
					a = types.InlineKeyboardButton("Back", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(res), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					res = urllib.urlopen("http://api.hektor-tm.ir/zekr/").read()
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("بازگذاری مجدد", callback_data='zekr'+str(target))
					a = types.InlineKeyboardButton(" بازگشت", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(res), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "hadis"+str(target):
				if not lang:
					res = urllib.urlopen("http://api.hektor-tm.ir/hadis/").read()
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("Reload", callback_data='hadis'+str(target))
					a = types.InlineKeyboardButton(" Back", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(res), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					res = urllib.urlopen("http://api.hektor-tm.ir/hadis/").read()
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("بازگذاری مجدد", callback_data='hadis'+str(target))
					a = types.InlineKeyboardButton(" بازگشت", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(res), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "danestani"+str(target):
				if not lang:
					res = urllib.urlopen("http://api.hektor-tm.ir/danestani/").read()
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("Reload", callback_data='danestani'+str(target))
					a = types.InlineKeyboardButton("Back", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(res), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					res = urllib.urlopen("http://api.hektor-tm.ir/danestani/").read()
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("بازگذاری مجدد", callback_data='danestani'+str(target))
					a = types.InlineKeyboardButton("بازگشت", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(res), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "fal"+str(target):
				if not lang:
					f = open("fal.db")
					text = f.read()
					text1 = text.split(",")
					last = random.choice(text1)
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("Reload", callback_data='fal'+str(target))
					a = types.InlineKeyboardButton(" Back", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(last), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				else:
					f = open("fal.db")
					text = f.read()
					text1 = text.split(",")
					last = random.choice(text1)
                                        markup = types.InlineKeyboardMarkup()
					b = types.InlineKeyboardButton("بازگذاری مجدد", callback_data='fal'+str(target))
					a = types.InlineKeyboardButton(" بازگشت", callback_data='funtools'+str(target))
					markup.add(b,a)
					bot.edit_message_text("`{}`".format(last), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "ownerlist"+str(target):
				if not lang:
					if not data[str(target)]['owners']:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton("Back", callback_data='option'+str(target))
						markup.add(a)
						bot.edit_message_text("*Ownerlist Is Not Available!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '*List Of Owners Of Group :*\n'
						for v in data[str(target)]['owners']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
							a = types.InlineKeyboardButton("Back", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id.format(message),reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if not data[str(target)]['owners']:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton("بازگشت", callback_data='option'+str(target))
						markup.add(a)
						bot.edit_message_text("`ليست مالکان يافت نشد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '`ليست مالکان گروه :`\n'
						for v in data[str(target)]['owners']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
							a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id.format(message),reply_markup=markup,parse_mode='Markdown')

			if call.data == "banlist"+str(target):
				if not lang:
					if not data[str(target)]["banned"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
                                                markup.add(a)
						bot.edit_message_text("*Banlist Is Not Available!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '*List Of Banned Users :*\n'
						for v in data[str(target)]['banned']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 Clean Banlist", callback_data='cleanban'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if not data[str(target)]["banned"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
                                                markup.add(a)
						bot.edit_message_text("`ليست سياه يافت نشد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '`ليست کاربران مسدود شده :`\n'
						for v in data[str(target)]['banned']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 پاک کردن ليست سياه", callback_data='cleanban'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "silentlist"+str(target):
				if not lang:
					if not data[str(target)]["is_silent_users"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Silentlist Is Not Available!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '*List Of Silented Users :*\n'
						for v in data[str(target)]['is_silent_users']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 Clean Silentlist", callback_data='cleansilent'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if not data[str(target)]["is_silent_users"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`ليست کاربران سايلنت شده يافت نشد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '`ليست کاربران سايلنت شده :`\n'
						for v in data[str(target)]['is_silent_users']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 پاک کردن ليست کاربران سايلنت شده", callback_data='cleansilent'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "whitelist"+str(target):
				if not lang:
					if not data[str(target)]["whitelist"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
						markup.add(a)
                                                bot.edit_message_text("*Whitelist Is Not Available!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '*Users Of Whitelist :*\n'
						for v in data[str(target)]['whitelist']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 Clean Whitelist", callback_data='cleanwhite'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if not data[str(target)]["whitelist"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
						markup.add(a)
                                                bot.edit_message_text("`ليست سفيد يافت نشد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '`کاربران ليست سفيد :`\n'
						for v in data[str(target)]['whitelist']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 پاک کردن ليست سفيد", callback_data='cleanwhite'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')


			if call.data == "modlist"+str(target):
				if not lang:
					if not data[str(target)]["mods"]:
                                                markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Modlist Is Not Available!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
                                        else:
						i = 1
                                                message = '*List Of Fire Of Group :*\n'
                                                for v in data[str(target)]['mods']:
							message = '{}{} - {}\n'.format(message,i,v)
                                                        i = i + 1
							markup = types.InlineKeyboardMarkup()
							a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
                                                        markup.add(a)
                                                        bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if not data[str(target)]["mods"]:
                                                markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`ليست مديران يافت نشد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
                                        else:
						i = 1
                                                message = '`ليست مديران گروه :`\n'
                                                for v in data[str(target)]['mods']:
							message = '{}{} - {}\n'.format(message,i,v)
                                                        i = i + 1
							markup = types.InlineKeyboardMarkup()
							a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
                                                        markup.add(a)
                                                        bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "filterlist"+str(target):
				if not lang:
					if not data[str(target)]["filterlist"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Filterlist Is Not Available!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '*List Of Filtered Words :*\n'
						for v in data[str(target)]['filterlist']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 Clean Filterlist", callback_data='cleanfilter'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lang:
					if not data[str(target)]["filterlist"]:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("`ليست کلمات فيلتر شده يافت نشد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						i = 1
						message = '`ليست کلمات فيلتر شده :`\n'
						for v in data[str(target)]['filterlist']:
							message = '{}{} - {}\n'.format(message,i,v)
							i = i + 1
							markup = types.InlineKeyboardMarkup()
                                                        b = types.InlineKeyboardButton("🗑 پاک کردن ليست کلمات فيلتر شده", callback_data='cleanfilter'+str(target))
                                                        markup.add(b)
							a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
							markup.add(a)
							bot.edit_message_text("{}".format(message), inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
			if call.data == "cleanban"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Yes", callback_data='ban'+str(target))
					b = types.InlineKeyboardButton("No", callback_data='banlist'+str(target))
					markup.add(a,b)
					bot.edit_message_text("*Are You Sure?*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("بله", callback_data='ban'+str(target))
                                        b = types.InlineKeyboardButton("خير", callback_data='banlist'+str(target))
					bot.edit_message_text("`آيا مطمئن هستيد؟`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "ban"+str(target):
				if not lang:
					data[str(target)]["banned"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("*Banlist Has Been Cleaned!*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					data[str(target)]["banned"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("`ليست سياه پاک شد!`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "cleanfilter"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Yes", callback_data='filter'+str(target))
					b = types.InlineKeyboardButton("No", callback_data='filterlist'+str(target))
					markup.add(a,b)
					bot.edit_message_text("*Are You Sure?*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("بله", callback_data='filter'+str(target))
                                        b = types.InlineKeyboardButton("خير", callback_data='filterlist'+str(target))
					bot.edit_message_text("`آيا مطمئن هستيد؟`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "filter"+str(target):
				if not lang:
					data[str(target)]["filterlist"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("*Filterlist Has Been Cleaned!*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					data[str(target)]["filterlist"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("`ليست کلمات فيلتر شده پاک شد!`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "cleanwhite"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Yes", callback_data='white'+str(target))
					b = types.InlineKeyboardButton("No", callback_data='whitelist'+str(target))
					markup.add(a,b)
					bot.edit_message_text("*Are You Sure?*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("بله", callback_data='white'+str(target))
                                        b = types.InlineKeyboardButton("خير", callback_data='whitelist'+str(target))
					bot.edit_message_text("`آيا مطمئن هستيد؟`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "white"+str(target):
				if not lang:
					data[str(target)]["whitelist"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("*Whitelist Has Been Cleaned!*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					data[str(target)]["whitelist"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("`ليست سفيد پاک شد!`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "cleansilent"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Yes", callback_data='silent'+str(target))
					b = types.InlineKeyboardButton("No", callback_data='silentlist'+str(target))
					markup.add(a,b)
					bot.edit_message_text("*Are You Sure?*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("بله", callback_data='silent'+str(target))
                                        b = types.InlineKeyboardButton("خير", callback_data='silentlist'+str(target))
					bot.edit_message_text("`آيا مطمئن هستيد؟`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "silent"+str(target):
				if not lang:
					data[str(target)]["is_silent_users"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("*Silentlist Has Been Cleaned!*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					data[str(target)]["is_silent_users"] = {}
					save_data(dos, data)
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("`ليست کاربران سايلنت شده پاک شد!`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "lock_pin"+str(target):
				if lock_pin == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_pin"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Pinned Message Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_pin"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`سنجاق کردن پيام آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_pin == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_pin"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Pinned Message Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_pin"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`سنجاق کردن پيام قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "welcome"+str(target):
				if welcome == "yes":
					if not lang:
						data[str(target)]["settings"]["welcome"] = "no"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Welcome Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["welcome"] = "no"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`پيام خوشامد گويي غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif welcome == "no":
					if not lang:
						data[str(target)]["settings"]["welcome"] = "yes"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Welcome Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["welcome"] = "yes"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`پيام خوشامد گوشش فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_link"+str(target):
				if lock_link == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_link"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Link Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_link"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`لينک آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_link == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_link"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Link Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_link"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`لينک قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_username"+str(target):
				if lock_username == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_username"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Username Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_username"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`نام کاربری آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_username == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_username"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Username Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_username"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`نام کاربری قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_english"+str(target):
				if lock_english == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_english"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*English Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_english"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`انگلیسی آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_english == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_english"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*English Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_english"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`انگلیسی قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
						
			if call.data == "lock_all"+str(target):
				if lock_all == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_all"] = "unlock"
						data[str(target)]["settings"]["lock_link"] = "unlock"
						data[str(target)]["settings"]["lock_tag"] = "unlock"
						data[str(target)]["settings"]["lock_username"] = "unlock"
						data[str(target)]["settings"]["lock_edit"] = "unlock"
						data[str(target)]["settings"]["lock_join"] = "unlock"
						data[str(target)]["settings"]["lock_flood"] = "unlock"
						data[str(target)]["settings"]["lock_spam"] = "unlock"
						data[str(target)]["settings"]["lock_mention"] = "unlock"
						data[str(target)]["settings"]["lock_markdown"] = "unlock"
						data[str(target)]["settings"]["lock_arabic"] = "unlock"
						data[str(target)]["settings"]["lock_english"] = "unlock"
						data[str(target)]["settings"]["lock_webpage"] = "unlock"
						data[str(target)]["settings"]["lock_pin"] = "unlock"
						data[str(target)]["settings"]["lock_bots"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*All Settings Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_all"] = "unlock"
						data[str(target)]["settings"]["lock_link"] = "unlock"
						data[str(target)]["settings"]["lock_tag"] = "unlock"
						data[str(target)]["settings"]["lock_username"] = "unlock"
						data[str(target)]["settings"]["lock_edit"] = "unlock"
						data[str(target)]["settings"]["lock_join"] = "unlock"
						data[str(target)]["settings"]["lock_flood"] = "unlock"
						data[str(target)]["settings"]["lock_spam"] = "unlock"
						data[str(target)]["settings"]["lock_mention"] = "unlock"
						data[str(target)]["settings"]["lock_markdown"] = "unlock"
						data[str(target)]["settings"]["lock_arabic"] = "unlock"
						data[str(target)]["settings"]["lock_english"] = "unlock"
						data[str(target)]["settings"]["lock_webpage"] = "unlock"
						data[str(target)]["settings"]["lock_pin"] = "unlock"
						data[str(target)]["settings"]["lock_bots"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`همه تنظیمات آزاد شدند!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_all == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_all"] = "lock"
						data[str(target)]["settings"]["lock_link"] = "lock"
						data[str(target)]["settings"]["lock_tag"] = "lock"
						data[str(target)]["settings"]["lock_username"] = "lock"
						data[str(target)]["settings"]["lock_edit"] = "lock"
						data[str(target)]["settings"]["lock_join"] = "lock"
						data[str(target)]["settings"]["lock_flood"] = "lock"
						data[str(target)]["settings"]["lock_spam"] = "lock"
						data[str(target)]["settings"]["lock_mention"] = "lock"
						data[str(target)]["settings"]["lock_markdown"] = "lock"
						data[str(target)]["settings"]["lock_arabic"] = "lock"
						data[str(target)]["settings"]["lock_english"] = "lock"
						data[str(target)]["settings"]["lock_webpage"] = "lock"
						data[str(target)]["settings"]["lock_pin"] = "lock"
						data[str(target)]["settings"]["lock_bots"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*All Settings Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_all"] = "lock"
						data[str(target)]["settings"]["lock_link"] = "lock"
						data[str(target)]["settings"]["lock_tag"] = "lock"
						data[str(target)]["settings"]["lock_username"] = "lock"
						data[str(target)]["settings"]["lock_edit"] = "lock"
						data[str(target)]["settings"]["lock_join"] = "lock"
						data[str(target)]["settings"]["lock_flood"] = "lock"
						data[str(target)]["settings"]["lock_spam"] = "lock"
						data[str(target)]["settings"]["lock_mention"] = "lock"
						data[str(target)]["settings"]["lock_markdown"] = "lock"
						data[str(target)]["settings"]["lock_arabic"] = "lock"
						data[str(target)]["settings"]["lock_english"] = "lock"
						data[str(target)]["settings"]["lock_webpage"] = "lock"
						data[str(target)]["settings"]["lock_pin"] = "lock"
						data[str(target)]["settings"]["lock_bots"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`همه تنظیمات قفل شدند!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_tag"+str(target):
				if lock_tag == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_tag"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Tag Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_tag"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`تگ آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_tag == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_tag"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Tag Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_tag"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`تگ قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')


			if call.data == "lock_spam"+str(target):
				if lock_spam == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_spam"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Spam Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_spam"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`هرزنامه آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_spam == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_spam"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Spam Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_spam"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`هرزنامه قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_webpage"+str(target):
				if lock_webpage == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_webpage"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Webpage Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_webpage"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`صفحات وب آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_webpage == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_webpage"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Webpage Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_webpage"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`صفحات وب قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_markdown"+str(target):
				if lock_markdown == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_markdown"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Markdown Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_markdown"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`فونت آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_markdown == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_markdown"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Markdown Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_markdown"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`فونت قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_bots"+str(target):
				if lock_bots == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_bots"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Bots Protection Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_bots"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ورود ربات (api) آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_bots == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_bots"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Bots Protection Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_bots"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ورود ربات (api) قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_flood"+str(target):
				if lock_flood == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_flood"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Flood Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_flood"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ارسال پيام مکرر آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_flood == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_flood"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Flood Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_flood"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ارسال پيام مکرر قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_join"+str(target):
				if lock_join == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_join"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Join Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_join"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ورود اعضا آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_join == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_join"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Join Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_join"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ورود اعضا قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_mention"+str(target):
				if lock_mention == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_mention"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mention Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_mention"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`فراخواني آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_mention == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_mention"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mention Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_mention"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`فراخواني قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_arabic"+str(target):
				if lock_arabic == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_arabic"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Arabic/Persian Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_arabic"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`عربي/فارسي آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_arabic == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_arabic"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Arabic/Persian Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_arabic"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`عربي/فارسي قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "lock_edit"+str(target):
				if lock_edit == "lock":
					if not lang:
						data[str(target)]["settings"]["lock_edit"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Edit Has Been Unlocked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_edit"] = "unlock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ويرايش پيام آزاد شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif lock_edit == "unlock":
					if not lang:
						data[str(target)]["settings"]["lock_edit"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("*Edit Has Been Locked!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["settings"]["lock_edit"] = "lock"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='settings'+str(target))
						markup.add(a)
						bot.edit_message_text("`ويرايش پيام قفل شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_audio"+str(target):
				if mute_audio == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_audio"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Audio Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_audio"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي آهنگ غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_audio == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_audio"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Audio Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_audio"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي آهنگ فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_tgservice"+str(target):
				if mute_tgservice == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_tgservice"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute TgService Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_tgservice"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي سرويس تلگرام غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_tgservice == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_tgseervice"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute TgService Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_tgservice"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي سرويس تلگرام فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_text"+str(target):
				if mute_text == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_text"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Text Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_text"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي متن غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_text == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_text"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Text Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_text"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي متن فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_inline"+str(target):
				if mute_inline == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_inline"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Inline Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_inline"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي کيبورد شيشه اي غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_inline == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_inline"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Inline Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_inline"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي کيبورد شيشه اي فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_voice"+str(target):
				if mute_voice == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_voice"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Voice Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_voice"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي صدا غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_voice == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_voice"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Voice Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_voice"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي صدا فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_sticker"+str(target):
				if mute_sticker == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_sticker"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Sticker Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_sticker"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي برچسب غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_sticker == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_sticker"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Sticker Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_sticker"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي برچسب فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_contact"+str(target):
				if mute_contact == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_contact"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Contact Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_contact"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي مخاطب غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_contact == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_contact"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Contact Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_contact"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي مخاطب فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_document"+str(target):
				if mute_document == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_doc"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Document Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_doc"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي فايل غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_document == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_doc"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Document Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_doc"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي فايل فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_forward"+str(target):
				if mute_forward == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_fwd"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Forward Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_fwd"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي نقل قول غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_forward == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_fwd"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Forward Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_fwd"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي نقل قول فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_gif"+str(target):
				if mute_gif == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_gif"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Gif Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_gif"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي تصاوير متحرک غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_gif == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_gif"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Gif Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_gif"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي تصاوير متحرک فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_location"+str(target):
				if mute_location == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_loc"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Location Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_loc"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي موقعيت مکاني غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_location == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_loc"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Location Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_loc"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي موقعيت مکاني فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_photo"+str(target):
				if mute_photo == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_photos"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Photo Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_photos"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي عکس غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_photo == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_photos"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Photo Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_photos"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي عکس فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_video"+str(target):
				if mute_video == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_video"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Video Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_video"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي فيلم غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_video == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_video"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Video Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_video"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي فيلم فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_game"+str(target):
				if mute_game == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_game"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Game Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_game"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي بازي هاي تحت وب غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_game == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_game"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Game Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_game"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي بازي هاي تحت وب فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_keyboard"+str(target):
				if mute_keyboard == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_keyboard"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Keyboard Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_keyboard"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي صفحه کليد غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_keyboard == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_keyboard"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute Keyboard Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_keyboard"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي صفحه کليد فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "mute_all"+str(target):
				if mute_all == "mute":
					if not lang:
						data[str(target)]["mutes"]["mute_all"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutlist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute All Has Been Disabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_all"] = "unmute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي همه پيام ها غيرفعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
				elif mute_all == "unmute":
					if not lang:
						data[str(target)]["mutes"]["mute_all"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("*Mute All Has Been Enabled!*", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')
					else:
						data[str(target)]["mutes"]["mute_all"] = "mute"
						save_data(dos, data)
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='mutelist'+str(target))
						markup.add(a)
						bot.edit_message_text("`بيصداي همه پيام ها فعال شد!`", inline_message_id = call.inline_message_id,reply_markup=markup,parse_mode='Markdown')

			if call.data == "gplink"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("_Group Link For_ *{} :*\n{}".format(gpname,gplink), inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("`لينک گروه براي` *{} :*\n{}".format(gpname,gplink), inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "rules"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("_Group Rules For_ *{} :*\n{}".format(gpname,gprules), inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
					markup.add(a)
					bot.edit_message_text("`قوانین گروه براي` *{} :*\n{}".format(gpname,gprules), inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "expire"+str(target):
				if not lang:
					if redis.ttl("ExpireDate:{}".format(target)) == -1:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
                                                markup.add(a)
                                                bot.edit_message_text("*Unlimited*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
					else:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" Back", callback_data='option'+str(target))
						markup.add(a)
						bot.edit_message_text("_Group Expire Date_ : *{} Days*".format(int(redis.ttl("ExpireDate:"+str(target)) / 86400) + 1), inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				elif lang:
					if redis.ttl("ExpireDate:{}".format(target)) == -1:
						markup = types.InlineKeyboardMarkup()
	                                        a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
        	                                markup.add(a)
                	                        bot.edit_message_text("`نامحدود`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
					else:
						markup = types.InlineKeyboardMarkup()
						a = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
						markup.add(a)
						bot.edit_message_text("`تاریخ انقضای گروه: {} روز`".format(int(redis.ttl("ExpireDate:"+str(target)) / 86400) +1), inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')

			if call.data == "about"+str(target):
				if not lang:
					markup = types.InlineKeyboardMarkup()
					n = types.InlineKeyboardButton(text="tel_fire", url="https://telegram.me/tel_fire")
					markup.add(n)
					h = types.InlineKeyboardButton("Back", callback_data='option'+str(target))
					markup.add(h)
					bot.edit_message_text("*MaTaDoR Helper Bot Version 1.0*", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton(text="tel_fire", url="https://telegram.me/tel_fire")
                                        markup.add(a)
					h = types.InlineKeyboardButton(" بازگشت", callback_data='option'+str(target))
					markup.add(h)
					bot.edit_message_text("`هلپرفایر ورژن 1 فایر`", inline_message_id = call.inline_message_id, reply_markup=markup, parse_mode='Markdown')
		else:
			if not lang:
					bot.answer_callback_query(callback_query_id=call.id, show_alert=True, text="You're Not Moderator!")

			else:
					bot.answer_callback_query(callback_query_id=call.id, show_alert=True, text="شما دسترسي نداريد!")
    except:
	print("\033[01;31m Bot Has Been Crashed! \033[0m")


@bot.inline_handler(lambda query: query.query)
def option(query):
		target = query.query.split()[0]
		lang = redis.get("gp_lang:{}".format(target))
		if query.from_user.id == sudo:
			if target and query.query.split()[1] == "option":
				if not lang:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("Group Language", callback_data='gplang'+str(target))
				        markup.add(a)
					a = types.InlineKeyboardButton("About", callback_data='about'+str(target))
					b = types.InlineKeyboardButton("Group Expire Date", callback_data='expire'+str(target))
					markup.add(a,b)
					a = types.InlineKeyboardButton("Group Rules", callback_data='rules'+str(target))
					b = types.InlineKeyboardButton("Group Link", callback_data='gplink'+str(target))
					markup.add(a,b)
					c = types.InlineKeyboardButton("Banlist", callback_data='banlist'+str(target))
					g = types.InlineKeyboardButton("SilentList", callback_data='silentlist'+str(target))
					markup.add(c,g)
					h = types.InlineKeyboardButton("Filterlist", callback_data='filterlist'+str(target))
					j = types.InlineKeyboardButton("Whitelist", callback_data='whitelist'+str(target))
					markup.add(h,j)
					o = types.InlineKeyboardButton("Ownerlist", callback_data='ownerlist'+str(target))
					u = types.InlineKeyboardButton("Modlist", callback_data='modlist'+str(target))
					markup.add(o,u)
					k = types.InlineKeyboardButton("Settings", callback_data='settings'+str(target))
					markup.add(k)
					a = types.InlineKeyboardButton("Fun Tools", callback_data='funtools'+str(target))
					markup.add(a)
					url = 'http://static.nautil.us/3006_5f268dfb0fbef44de0f668a022707b86.jpg'
					option = types.InlineQueryResultArticle('1', 'Group Option',types.InputTextMessageContent('🛠 *Welcome To Group Option!*', parse_mode='Markdown'),reply_markup=markup,thumb_url=url)
					bot.answer_inline_query(query.id, [option], cache_time='5')
				else:
					markup = types.InlineKeyboardMarkup()
					a = types.InlineKeyboardButton("زبان گروه", callback_data='gplang'+str(target))
				        markup.add(a)
					a = types.InlineKeyboardButton("درباره ربات", callback_data='about'+str(target))
					b = types.InlineKeyboardButton("تاریخ انقضای گروه", callback_data='expire'+str(target))
					markup.add(a,b)
					a = types.InlineKeyboardButton("قوانین گروه", callback_data='rules'+str(target))
					b = types.InlineKeyboardButton("لینک گروه", callback_data='gplink'+str(target))
					markup.add(a,b)
					c = types.InlineKeyboardButton("ليست سياه", callback_data='banlist'+str(target))
					g = types.InlineKeyboardButton("ليست کاربران سايلنت شده", callback_data='silentlist'+str(target))
					markup.add(c,g)
					h = types.InlineKeyboardButton("ليست کلمات فيلتر شده", callback_data='filterlist'+str(target))
					j = types.InlineKeyboardButton("ليست سفيد", callback_data='whitelist'+str(target))
					markup.add(h,j)
					o = types.InlineKeyboardButton("ليست مالکان", callback_data='ownerlist'+str(target))
					u = types.InlineKeyboardButton("ليست مديران", callback_data='modlist'+str(target))
					markup.add(o,u)
					k = types.InlineKeyboardButton("تنظيمات", callback_data='settings'+str(target))
					markup.add(k)
					a = types.InlineKeyboardButton("ابزار سرگرمی", callback_data='funtools'+str(target))
					markup.add(a)
					url = 'http://static.nautil.us/3006_5f268dfb0fbef44de0f668a022707b86.jpg'
					option = types.InlineQueryResultArticle('1', 'تنظيمات گروه',types.InputTextMessageContent('🛠 `به تنظيمات گروه خوش آمديد!`', parse_mode='Markdown'),reply_markup=markup,thumb_url=url)
					bot.answer_inline_query(query.id, [option], cache_time='5')

bot.polling(True)
