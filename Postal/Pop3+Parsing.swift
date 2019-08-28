//
//  Pop3+Parsing.swift
//  Postal
//
//  Created by Gennaro Stanzione on 28/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import Foundation
import libetpan

struct AbstractPart {
    func applyUniquePartID() {
        
    }
}

extension UnsafeMutablePointer where Pointee == mailmessage {
    func parse() throws -> Int32 {

        var mime: UnsafeMutablePointer<mailmime>?
        try mailmessage_get_bodystructure(self, &mime).toPop3Error?.check()
        
        let mainPart = mime?.attachmentsWithMIMEWithMain(isMain: true)
        mainPart?.applyUniquePartID()
        
        
        
        
        
        
        /*
        if let parts = mime?.pointee.parse("--GENNY--") {
            print("descs: \(parts.description)")
        }
        
        if let parts2 = self.pointee.msg_mime.pointee.parse("--GENNY2--") {
            print("DESC: \(parts2.description)")
            
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
        
        
        
        
        /*
        let abstractPart = self.pointee.msg_mime.attachmentsWithMIMEWithMain(isMain: true)
//        abstractPart.applyUniquePartID // TODO
        
        mailimf_envelope_and_optional_fields_parse(<#T##message: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##length: Int##Int#>, <#T##indx: UnsafeMutablePointer<Int>!##UnsafeMutablePointer<Int>!#>, <#T##result: UnsafeMutablePointer<UnsafeMutablePointer<mailimf_fields>?>!##UnsafeMutablePointer<UnsafeMutablePointer<mailimf_fields>?>!#>)
        */
        /*
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
        
        
        return Int32(MAILPOP3_NO_ERROR)
    }
}

extension UnsafeMutablePointer where Pointee == mailmime {
    func parse() throws -> Int32 {
        
        return Int32(MAILPOP3_NO_ERROR)
    }
    
    func attachmentsWithMIMEWithMain(isMain: Bool) -> AbstractPart? {
        
        switch self.pointee.mm_type {
        case Int32(MAILMIME_SINGLE):
            break
        case Int32(MAILMIME_MULTIPLE):
            break
        case Int32(MAILMIME_MESSAGE):
            break
        default:
            return nil
        }
        
        return nil
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
        
        return NULL;
        */
        
        
    }
}


class Attachment {
    
    static func attachmentWithSingleMIME(_ mime: mailmime) -> Attachment {
        
        let result = Attachment()
        
        
        
        
        
        return result
        
        
    }
    
}

/*
Attachment * Attachment::attachmentWithSingleMIME(struct mailmime * mime)
{
    struct mailmime_data * data;
    const char * bytes;
    size_t length;
    Attachment * result;
    struct mailmime_single_fields single_fields;
    char * str;
    char * name;
    char * filename;
    char * content_id;
    char * description;
    char * loc;
    Encoding encoding;
    clist * ct_parameters;
    
    MCAssert(mime->mm_type == MAILMIME_SINGLE);
    
    result = new Attachment();
    result->setUniqueID(mailcore::String::uuidString());
    
    data = mime->mm_data.mm_single;
    bytes = data->dt_data.dt_text.dt_data;
    length = data->dt_data.dt_text.dt_length;
    
    mailmime_single_fields_init(&single_fields, mime->mm_mime_fields, mime->mm_content_type);
 
    encoding = encodingForMIMEEncoding(single_fields.fld_encoding, data->dt_encoding);
    
    Data * mimeData;
    mimeData = Data::dataWithBytes(bytes, (unsigned int) length);
    mimeData = mimeData->decodedDataUsingEncoding(encoding);
    result->setData(mimeData);
    
    str = get_content_type_str(mime->mm_content_type);
    result->setMimeType(String::stringWithUTF8Characters(str));
    free(str);
    
    name = single_fields.fld_content_name;
    filename = single_fields.fld_disposition_filename;
    content_id = single_fields.fld_id;
    description = single_fields.fld_description;
    loc = single_fields.fld_location;
    ct_parameters = single_fields.fld_content->ct_parameters;
    
    if (filename != NULL) {
        result->setFilename(String::stringByDecodingMIMEHeaderValue(filename));
    }
    else if (name != NULL) {
        result->setFilename(String::stringByDecodingMIMEHeaderValue(name));
    }
    if (content_id != NULL) {
        result->setContentID(String::stringWithUTF8Characters(content_id));
    }
    if (description != NULL) {
        result->setContentDescription(String::stringWithUTF8Characters(description));
    }
    if (single_fields.fld_content_charset != NULL) {
        result->setCharset(String::stringByDecodingMIMEHeaderValue(single_fields.fld_content_charset));
    }
    if (loc != NULL) {
        result->setContentLocation(String::stringWithUTF8Characters(loc));
    }
    
    if (ct_parameters != NULL) {
        clistiter * iter = clist_begin(ct_parameters);
        struct mailmime_parameter * param;
        while (iter != NULL) {
            param = (struct mailmime_parameter *) clist_content(iter);
            if (param != NULL) {
                if ((strcasecmp("name", param->pa_name) != 0) && (strcasecmp("charset", param->pa_name) != 0)) {
                    result->setContentTypeParameter(String::stringWithUTF8Characters(param->pa_name), String::stringWithUTF8Characters(param->pa_value));
                }
            }
            iter = clist_next(iter);
        }
    }
    
    if (single_fields.fld_disposition != NULL) {
        if (single_fields.fld_disposition->dsp_type != NULL) {
            if (single_fields.fld_disposition->dsp_type->dsp_type == MAILMIME_DISPOSITION_TYPE_INLINE) {
                result->setInlineAttachment(true);
            }
            else if (single_fields.fld_disposition->dsp_type->dsp_type == MAILMIME_DISPOSITION_TYPE_ATTACHMENT) {
                result->setAttachment(true);
            }
        }
    }
    
    return (Attachment *) result->autorelease();
}
*/
