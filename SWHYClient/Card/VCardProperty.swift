//
//  VCardProperty.swift
//  SwiftyVCard
//
//  Created by Ruslan on 29.10.15.
//  Copyright © 2015 GRG. All rights reserved.
//

import Foundation

public enum VCardProperty: String {
    case N = "N;CHARSET=utf-8"
    case FN = "FN;CHARSET=utf-8"
    case TITLE = "TITLE;CHARSET=utf-8"
    case EMAIL = "EMAIL;WORK;CHARSET=utf-8"
    case ORG = "ORG;WORK;CHARSET=utf-8"
    case URL = "URL;HOMEPAGE;CHARSET=utf-8"
    case TEL = "TEL;WORK;CHARSET=utf-8"
    case ADR = "ADR;WORK;CHARSET=utf-8"
    case MOBILE = "TEL;CELL;CHARSET=utf-8"
    case FAX = "TEL;WORK;FAX;CHARSET=utf-8"
    case MEMO = "LABEL;CHARSET=utf-8"
}
