//
//  Pop3Session+Fetch.swift
//  Postal
//
//  Created by Gennaro Stanzione on 27/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import Foundation
import libetpan

private struct MessageInfo {
    var index: UInt32
    var uid: String
    var size: UInt32
}

extension Pop3Session: Fetcher {

    func fetchLast(_ folder: String, last: UInt, flags: FetchFlag, extraHeaders: Set<String>, handler: @escaping (FetchResult) -> Void) throws {
        print("fetch last")
        try fetchMessages(folder, uids: IndexSet(integer: 0), flags: flags, extraHeaders: extraHeaders, onMessage: handler)
    }
    
    func fetchMessages(_ folder: String, uids: IndexSet, flags: FetchFlag, extraHeaders: Set<String>, onMessage: @escaping (FetchResult) -> Void) throws {
        
        print("fetch messages")
//        try connect(timeout: 30)
        //try login()
        
        var msgList: UnsafeMutablePointer<carray>?

        
        try mailpop3_list(pop3, &msgList).toPop3Error?.check()
        print("message count: \(carray_count(msgList))") // 2147
        print("message max: \(msgList!.pointee.max)")

        /*for index in UInt(carray_count(msgList!)) {
            
        }*/
        
        
        let infos = sequence(msgList!, of: mailpop3_msg_info.self).reduce([MessageInfo]()) { (current, info) -> [MessageInfo] in
            var mCurrent = current
            mCurrent.append(MessageInfo(index: info.msg_index, uid: String(cString: info.msg_uidl), size: info.msg_size))
            return mCurrent
        }
        
        
        let info = infos[0]
        
        var rawRes: UnsafeMutablePointer<Int8>?
        var len: Int = 0
        
        if let error = mailpop3_retr(self.pop3, info.index, &rawRes, &len).toPop3Error {
            print("errore scaricando email: \(error.asPostalError.localizedDescription): \(error.asPostalError.toString). Index: \(info.index)")
        }
        else if let res = rawRes {
//            let data = Data(bytes: res, count: len)
            
            
            
            print("count prima: \(len)")
            
            var dataBytes = res
            var dataLength = len
            
            if (dataLength > 5) {
                var start: UnsafeMutablePointer<Int8>?
                var length = 0
                
                if strncmp(dataBytes, "From ", 5) == 0 {
                    start = dataBytes
                    for i in 0..<dataLength {
                        let item = start!.advanced(by: i)
                        if strncmp(item, "\n", 2) == 0 {
                            start = start! + i + 1
                            length = dataLength - (i + 1)
                            break
                        }
                    }
                }

                if let newStart = start {
                    dataBytes = newStart
                    dataLength = length
                }
            }
            
            
            print("count dopo: \(dataLength)")
            let data = Data(bytes: dataBytes, count: dataLength)
//            let parser = MCOMessageParser(data: data)
            
            

            let msg = data_message_init(dataBytes, dataLength)
            
            try msg?.parse().toPop3Error?.check()
            
            
            
            /*
            // Header
            var cur_token: size_t = 0
            var fields: UnsafeMutablePointer<mailimf_fields>?
            
            try mailimf_envelope_and_optional_fields_parse(dataBytes, dataLength, &cur_token, &fields).toPop3Error?.check()

            var singleFields = mailimf_single_fields_new(fields!)!.pointee
            
            mailimf_single_fields_init(&singleFields, fields)
            
            if (singleFields.fld_subject != nil) {

                let subject = singleFields.fld_subject.pointee.sbj_value
                
                let mSubject = String.fromZeroSizedCStringMimeHeader(subject)
                
                
                print("subj: \(mSubject)")
                //String.fromCStringMimeHeader(singleFields.fld_subject, length: <#T##Int#>)
                
                //let str = String(data: subject!.pointee.sbj_value, encoding: .utf8)
                
                    //.fld_subject->sbj_value;
                //setSubject(String::stringByDecodingMIMEHeaderValue(subject));
            }
            */
            
            
            
            /*
            struct mailimf_single_fields single_fields;
            
            mailimf_single_fields_init(&single_fields, fields);
            
            /* date */
            
            if (single_fields.fld_orig_date != NULL) {
                time_t timestamp;
                timestamp = timestampFromDate(single_fields.fld_orig_date->dt_date_time);
                setDate(timestamp);
                setReceivedDate(timestamp);
                //MCLog("%lu %lu", (unsigned long) timestamp, date());
            }
            */
            
            
            
            /*
            size_t cur_token = 0;
            struct mailimf_fields * fields;
            int r = mailimf_envelope_and_optional_fields_parse(dataBytes, dataLength, &cur_token, &fields);
            if (r == MAILIMAP_NO_ERROR) {
                header()->importIMFFields(fields);
                mailimf_fields_free(fields);
            }
            */
            
            
            mailmessage_free(msg)
            
            
            
            
            
            
            /*
            var mime: UnsafeMutablePointer<mailmime>?
            try mailmessage_get_bodystructure(msg!, &mime).toPop3Error?.check()
            
            
            switch mime!.pointee.mm_type {
            case Int32(MAILMIME_SINGLE):
                break
                
            default:
                break
            }
            */
            
            
            /*
            switch (mime->mm_type) {
            case MAILMIME_SINGLE:
            {
                Attachment * attachment;
                attachment = attachmentWithSingleMIME(mime);
                return attachment;
                }
            case MAILMIME_MULTIPLE:
            {
                if ((mime->mm_content_type != NULL) && (mime->mm_content_type->ct_subtype != NULL) &&
                    (strcasecmp(mime->mm_content_type->ct_subtype, "alternative") == 0)) {
                    Multipart * attachment;
                    attachment = new Multipart();
                    attachment->setPartType(PartTypeMultipartAlternative);
                    fillMultipartSubAttachments(attachment, mime);
                    return (Multipart *) attachment->autorelease();
                }
                else if ((mime->mm_content_type != NULL) && (mime->mm_content_type->ct_subtype != NULL) &&
                    (strcasecmp(mime->mm_content_type->ct_subtype, "related") == 0)) {
                    Multipart * attachment;
                    attachment = new Multipart();
                    attachment->setPartType(PartTypeMultipartRelated);
                    fillMultipartSubAttachments(attachment, mime);
                    return (Multipart *) attachment->autorelease();
                }
                else if ((mime->mm_content_type != NULL) && (mime->mm_content_type->ct_subtype != NULL) &&
                    (strcasecmp(mime->mm_content_type->ct_subtype, "signed") == 0)) {
                    Multipart * attachment;
                    attachment = new Multipart();
                    attachment->setPartType(PartTypeMultipartSigned);
                    fillMultipartSubAttachments(attachment, mime);
                    return (Multipart *) attachment->autorelease();
                }
                else {
                    Multipart * attachment;
                    attachment = new Multipart();
                    fillMultipartSubAttachments(attachment, mime);
                    return (Multipart *) attachment->autorelease();
                }
                }
            case MAILMIME_MESSAGE:
            {
                if (isMain) {
                    AbstractPart * attachment;
                    attachment = attachmentsWithMIMEWithMain(mime->mm_data.mm_message.mm_msg_mime, false);
                    return attachment;
                }
                else {
                    MessagePart * messagePart;
                    messagePart = attachmentWithMessageMIME(mime);
                    return messagePart;
                }
                }
            }
            
            return NULL;*/
            
            /*
            mMainPart = (AbstractPart *) Attachment::attachmentsWithMIME(msg->msg_mime)->retain();
            mMainPart->applyUniquePartID();
            
            size_t cur_token = 0;
            struct mailimf_fields * fields;
            int r = mailimf_envelope_and_optional_fields_parse(dataBytes, dataLength, &cur_token, &fields);
            if (r == MAILIMAP_NO_ERROR) {
                header()->importIMFFields(fields);
                mailimf_fields_free(fields);
            }
            mailmessage_free(msg);
            
            setupPartID();
            */
            
            print("fatto")
            
//            mailmessage_get_bodystructure(msg, &mime);
            
            
            /*
            mailmessage * msg;
            struct mailmime * mime;
            
            msg = data_message_init(dataBytes, dataLength);
            */
            
        }
        
        /*
        
        // OK!
        
        var emails = [String]()
        
        print("sequence: \(infos.count)")
        
        for i in 0..<infos.count {
            let info = infos[i]
            print("entrato \(info.index)")

            var rawRes: UnsafeMutablePointer<Int8>?
            var len: Int = 0
            
            if let error = mailpop3_retr(self.pop3, info.index, &rawRes, &len).toPop3Error {
                print("errore scaricando email: \(error.asPostalError.localizedDescription): \(error.asPostalError.toString). Index: \(info.index)")
            }
            else {
                if let res = rawRes {
                    
                    print("count prima: \(len)")
                    
                    var dataBytes = res
                    var dataLength = len
                    
                    if (dataLength > 5) {
                        var start: UnsafeMutablePointer<Int8>?
                        var length = 0
                        
                        if strncmp(dataBytes, "From ", 5) == 0 {
                            start = dataBytes
                            for i in 0..<dataLength {
                                let item = start!.advanced(by: i)
                                if strncmp(item, "\n", 2) == 0 {
                                    start = start! + i + 1
                                    length = dataLength - (i + 1)
                                    break
                                }
                            }
                        }
                        
                        if let newStart = start {
                            dataBytes = newStart
                            dataLength = length
                        }
                    }
                    
                    
                    print("count dopo: \(dataLength)")
                    
                    /*
                    let data = Data(bytes: res, count: Int(info.size))
                    print("scaricato index: \(info.index)")
                    print("data c'è \(data.count)")
                    
                    if let str = String(data: data, encoding: .utf8) {
                        print("parsing ok: \(info.index)")
                        emails.append(str)
                    }
                    else if let str = String(data: data, encoding: .ascii) {
                        print("parsing ok: \(info.index)")
                        emails.append(str)
                    }
                    else {
                        print("parsing ko: \(info.index)")
                        emails.append("no_parse_gst")
                    }
                    */
                }
                else {
                    print("data non c'è: \(info.index)")
                }
            }
            
            mailpop3_retr_free(rawRes)
        }
        
        
        */
        
        
        
        
        
        
        
        
        
        

        /*
        let downloadGroup = DispatchGroup()

        var emails = [String]()

        print("sequence: \(infos.count)")
        
        for i in 0..<infos.count {
            
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                downloadGroup.enter()
                let info = infos[i]
                print("entrato \(info.index)")
                
                
                var rawRes: UnsafeMutablePointer<Int8>?
                var len: Int = 0
                
                if let error = mailpop3_retr(self.pop3, info.index, &rawRes, &len).toPop3Error {
                    print("errore scaricando email: \(error.asPostalError.localizedDescription): \(error.asPostalError.toString). Index: \(info.index)")
                }
                else {
                    if let res = rawRes {
                        let data = Data(bytes: res, count: Int(info.size))
//                        print("scaricato index: \(info.index)")
//                        print("data c'è \(data.count)")
                        
                        if let str = String(data: data, encoding: .utf8) {
//                            print("parsing ok: \(info.index)")
                            emails.append(str)
                        }
                        else if let str = String(data: data, encoding: .ascii) {
//                            print("parsing ok: \(info.index)")
                            emails.append(str)
                        }
                        else {
//                            print("parsing ko: \(info.index)")
                            emails.append("no_parse_gst")
                        }
                        
                    }
                    else {
//                        print("data non c'è: \(info.index)")
                    }
                }
                
                mailpop3_retr_free(rawRes)
                
//                print("esco \(info.index)")
                downloadGroup.leave()
                
            }

        }
 
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            //            completion?(storedError)
            print("Fine, ecco il numero di emails parserizzate: \(emails.count)")
        }
        */
        
        
        
        
        
        
        /*
        let q = DispatchQueue(label: "internal", qos: .utility, attributes: .concurrent)
        let downloadGroup = DispatchGroup()
        let _ = DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.concurrentPerform(iterations: infos.count) { index in

            downloadGroup.enter()
            
            let info = infos[index]
            var rawRes: UnsafeMutablePointer<Int8>?
            var len: Int = 0

            print("provo a scaricare index: \(info.index)")
            if let error = mailpop3_retr(pop3, info.index, &rawRes, &len).toPop3Error {
                
                q.async {
                    print("errore scaricando email: \(error.asPostalError.localizedDescription): \(error.asPostalError.toString)")
                    mailpop3_retr_free(rawRes)
                    downloadGroup.leave()
                }

                
            }
            else {

                q.async {

                    if let res = rawRes {
                        let data = Data(bytes: res, count: Int(info.size))
                        print("scaricato index: \(info.index)")
                        print("data c'è \(data.count)")
                        
                        if let str = String(data: data, encoding: .utf8) {
                            emails.append(str)
                        }
                        else if let str = String(data: data, encoding: .ascii) {
                            emails.append(str)
                        }
                        else {
                            emails.append("no_parse_gst")
                        }
                        
                    }
                    else {
                        print("data non c'è")
                    }
                    
                    mailpop3_retr_free(rawRes)
                    downloadGroup.leave()
                }
                
            }
            
//            mailpop3_retr_free(rawRes)
            
//            q.async {
//                downloadGroup.leave()
//            }
            
            
            
            
//            try mailpop3_retr(mPop, index, &content, &content_len)
            
            
            
            
            /*let address = addresses[index]
            let url = URL(string: address)
            downloadGroup.enter()
            let photo = DownloadPhoto(url: url!) { _, error in
                if error != nil {
                    storedError = error
                }
                downloadGroup.leave()
            }
            PhotoManager.shared.addPhoto(photo)*/
        }
        downloadGroup.notify(queue: DispatchQueue.main) {
//            completion?(storedError)
            print("Fine, ecco il numero di emails parserizzate: \(emails.count)")
        }
        */
        
        
        /*
        for(unsigned int i = 0 ; i < carray_count(msg_list) ; i ++) {
            struct mailpop3_msg_info * msg_info;
            String * uid;
            
            msg_info = (struct mailpop3_msg_info *) carray_get(msg_list, i);
            if (msg_info->msg_uidl == NULL)
            continue;
            
            uid = String::stringWithUTF8Characters(msg_info->msg_uidl);
            
            POPMessageInfo * info = new POPMessageInfo();
            info->setUid(uid);
            info->setSize(msg_info->msg_size);
            info->setIndex(msg_info->msg_index);
            result->addObject(info);
            info->release();
        }
        */
        
        
         //1
 
        
        /*
        var result: UnsafeMutablePointer<Int8>?
        var resultLen: Int = 0
        try mailpop3_top(pop3, 0, 0, &result, &resultLen).toPop3Error?.check()
        // 2484
        // 2242
        print("message count: \(resultLen)")
        mailpop3_top_free(result);
          */
    }
    
    func fetchParts(_ folder: String, uid: UInt, partId: String, handler: @escaping (MailData) -> Void) throws {
        
    }
    
    
}
