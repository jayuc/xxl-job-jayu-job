package com.github.jayuc.xxljob.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Component;

import com.xxl.job.core.biz.model.ReturnT;
import com.xxl.job.core.handler.IJobHandler;
import com.xxl.job.core.handler.annotation.JobHandler;
import com.xxl.job.core.log.XxlJobLogger;

@JobHandler(value="warnJobHandler")
@Component
public class WarnJobHandler extends IJobHandler {
	
	@Autowired
	MailSender mailSender;
	
	@Value("${spring.mail.username}")
	private String mailForm;

	@Override
	public ReturnT<String> execute(String param) throws Exception {
		XxlJobLogger.log("开始执行提醒任务, param: " + param);
		
		SimpleMailMessage message = getMessage(param);
		if(null != message) {
			XxlJobLogger.log(message.toString());
		}else {
			XxlJobLogger.log("无可执行的任务");
			return FAIL;
		}
		
		try {
			mailSender.send(message);
		} catch (Exception e) {
			XxlJobLogger.log("执行出错");
			XxlJobLogger.log(e);
			return FAIL;
		}
		
		XxlJobLogger.log("任务执行完毕");
		return SUCCESS;
	}
	
	private SimpleMailMessage getMessage(String param) {
		if(param != null && param.length() > 0) {
			String[] arr = param.split(";");
			XxlJobLogger.log("arr len: " + arr.length);
			if(arr.length > 2) {
				XxlJobLogger.log(" ------ to: " + arr[0]);
				SimpleMailMessage message = new SimpleMailMessage();
				message.setFrom(mailForm);
				message.setTo(arr[0]);
				message.setSubject(arr[1]);
				message.setText(arr[2]);
				return message;
			}else {
				return null;
			}
		}
		return null;
	}

}
