%%%
Title = "CDR: Security Baseline"
area = "Internet"
workgroup = "cdrplus-core"

[seriesInfo]
name = "Internet-Draft"
value = "cdrplus-security-baseline-00"
stream = "independent"
status = "experimental"

date = 2022-06-27T00:00:00Z

[[author]]
initials="S."
surname="Low"
fullname="Stuart Low"
%%%

.# Abstract

The Consumer Data Right (CDR) Security Baseline profile is profile of the OAuth 2.0 Authorization Framework built upon the Financial-grade API Security Profile 1.0 Part 1 and Financial-grade API Security Profile 1.0 Part 2.

.# Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in [@!RFC 2119].

{mainmatter}

# Scope

This document specifies methods for the following:
  - method of obtaining OAuth2 tokens in an appropriately secure manner for protecting data designated under the CDR Rules

# Terms & Definitions

Data Holder
Data Recipient
Consumer
CDR Arrangement
Personally Identifiable Information (PII)
Pairwise Pseudonymous Identifier (PPID)
Software Product

# Data Holder

TODO: Explanation about DH

## Authorisation Server

The authorisation server **SHALL** support the provisions specified in clause 5.2.2 of [@!FAPI-1.0-Advanced].

In addition, the authorisation server

1. **SHALL** support the `response_type` of `code id_token`;
2. **SHALL** support the `response_type` of `code` in conjunction with the `response_mode` value `jwt`;
3. **SHALL NOT** accept JWT request objects passed by value (this overrides [@!FAPI-1.0-Advanced] clause 5.2.2-1);
4. **SHALL** require signed and encrypted ID Tokens (this overrides [@!FAPI-1.0-Advanced] clause 5.2.2.1-3);
5. **MUST** support the pushed authorisation request endpoint as described in [@!PAR] (this overrides [@!FAPI-1.0-Advanced] clause 5.2.2-11);
6. **SHALL NOT** support JWT request object by reference except when using [@!PAR]
7. **SHALL** authenticate the confidential client using `private_key_jwt` as specified in section 9 of OIDC (this overrides [@!FAPI-1.0-Advanced] clause 5.2.2-14);
8. **SHALL NOT** return PII from the authorisation endpoint;
9. **MUST** support the [@!OIDC-Core] scopes `openid` and `profile`;
10. **MUST** support the [@!OIDC-Core] claims `openid` and `profile`;
11. **SHALL** issue access tokens with a minimum of 2 and a maximum of 10 minute expiry times;
12. **SHALL** provide the lifetime of an access token as an attribute named `expires_in` within the token endpoint response;
13. **MUST** generate the `sub` as a PPID as described in Section 8 of [@!OIDC-Core];
14. **SHALL** issue `request_uri` values which expire between 10 seconds and 90 seconds;
15. **SHALL** issue `request_uri` which can only be used once;
16. **MUST NOT** specify duplicate `kid` parameters within the endpoint advertised at `jwks_uri`;
17. **MUST** support a Token End Point as specified in Section 3.1.3 of [@!OIDC-Core];
18. **MUST** support a UserInfo Endpoint as specified in Section 5.3 of [@!OIDC-Core];

### Authorisation Flow

During the authorisation flow, the authorisation server:
1. **MUST** request a user identifier that can uniquely identify the Consumer and that is already known by the Consumer;
2. **MUST** use a one-time password (OTP) provided to the Consumer through an existing channel or mechanism;
3. **MUST NOT** introduce unwarranted friction into the authentication process

#### One-Time Password (OTP)

The One-Time Password (OTP):
1. **MUST** be delivered using existing and preferred channels
2. **MUST** be numeric digits and be between 4 and 6 digits in length
3. **MUST** only be valid for CDR authentication purposes
4. **MUST** be invalidated after a reasonable period of time
5. **SHOULD** incorporate a level of pseudorandomness appropriate for the use case

### Endpoints

#### Discovery Document

The authorisation server SHALL support discovery, as defined in OpenID Connect Discovery 1.0 [@!OIDC-Discovery].

Additionally, the authorisation server SHOULD support discovery, as defined in [@!RFC8414].

In addition, the authorisation server
1. **MUST** support the `require_pushed_authorization_requests` parameter as described in [@!RFC9126] at the OpenID Connect Discovery 1.0 [@!OIDC-Discovery] endpoint
2. **MUST** support the `require_pushed_authorization_requests` parameter as described in [@!RFC9126] at the [@!RFC8414] endpoint
3. **SHOULD** advertise the `require_pushed_authorization_requests` as `true`

#### Introspection Endpoint

The authorisation server SHALL support an introspection endpoint, as defined in [@!RFC7662].

In addition, the introspection endpoint response:
1. **MUST** include the `exp` attribute
2. **MUST** include the `scope` attribute
3. **MUST NOT** include the `username` attribute

#### Revocation Endpoint

The authorisation server SHALL support an OAuth2 revocation endpoint, as defined in [@!RFC7009].

In addition, the revocation endpoint:
1. **MUST** support revocation of Refresh Tokens
2. **MUST** support revocation of Access Tokens

### Request Object

The request object submitted to the authorisation server:
1. **MUST** contain a `exp` claim, in accordance with [@!RFC7519] Section 4.1.4
2. **MUST** ensure the `exp` claim is less than or equal to `3600`
3. **MUST** contain a `nbf` claim in accordance with [@!RFC7519] Section 4.1.5

### Claims

The authorisation server:
1. **MUST** support the [@!OIDC-Core] claims of `sub`, `acr`, `auth_time`, `name`, `given_name` `family_name` and `last_updated`;
2. **MAY** support the [@!OIDC-Core] claims of `email`, `email_verified`, `phone_number` and `phone_number_verified`;
3. **MUST NOT** support any other claims outlined in [@!OIDC-Core];

### Authentication Context Class References (ACR)

The authorisation server **SHALL** support the following ACR values:
1. `urn:cds.au:cdr:2` where the authentication achieved matches the Credential Level `CL1` rules of [@!TDIF];
2. `urn:cds.au:cdr:3` where the authentication achieved matches the Credential Level `CL2` rules of [@!TDIF]

Additionally, the authorisation server **MUST** ensure all operations meet the requirements of `urn:cds.au:cdr:2` ACR value.

## Resource Server

The resource server shall support the provisions specified in clause 5.2.2 of [@!FAPI-1.0-Baseline].

In addition, the resource server:
1. **SHALL** provide identifiers which are unique per Software Product

# Data Recipient

TODO: Explanation about DR

## Authorisation Client

An authorisation client shall support the provisions specified in clause 5.2.3 and 5.2.4 of [@!FAPI-1.0-Baseline].

In addition, the authorisation client
1. Data Recipient Software Products MUST ONLY use a "request_uri" value once

# Supported Arrangement Types

Data Holders and Data Recipients **MUST** support the following:
1. CDR Sharing Arrangement V1 as described in [@!CDRPLUS-INFOSEC-SHARING-V1]

# TLS Considerations

Section 8.5 of [@!FAPI-1.0-Advanced] **SHALL** apply.

In addition:
1. Use of TLS 1.2 or higher is **REQUIRED**
3. Use of Mutual TLS is **REQUIRED** at all Authenticated Resource Server endpoints
4. Use of Mutual TLS is **REQUIRED** at all OAuth2 endpoints except where required for Discovery or Consumer browser access (ie. Authorisation endpoint)
5. All parties **SHALL** utilise certificates issued by the Ecosystem Authority
6. All sender constrained tokens **SHALL** be issued in accordance with [@!RFC8705] Part 3

# Implementation Considerations

Note: For non-individual consumers, claims available via the profile scope will only return the details of the authenticated End-User and not the organisation or non-individual consumer. Data Holders SHOULD explicitly capture Claims requested by the Data Recipient. If the data cluster or [OIDC] profile scope changes meaning in future this ensures the Data Holder only returns what the consumer initially authorised to disclose.

# Security Considerations

5. SHOULD implement additional controls to minimise the risk of interception of the OTP through the selected delivery mechanism
6. Data Recipient Software Products SHOULD record the following information each time an authorisation flow is executed: username (consumer’s ID at the Data Recipient Software Product), timestamp, IP, consent scopes and duration.
7. Data Holders SHOULD implement additional controls to minimise the risk of enumeration attacks via the redirect page

In line with CDR Rule 4.24 on restrictions when asking CDR consumers to authorise disclosure of CDR data, unwarranted friction for OTP delivery is considered to include:

the addition of any requirements beyond normal data holder practices for verification code delivery
providing or requesting additional information beyond normal data holder practices for verification code delivery
offering additional or alternative services
reference or inclusion of other documents

