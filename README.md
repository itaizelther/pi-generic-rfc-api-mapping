# SAP PI Generic RFC API Mapping
A mapping written in XSLT that can be used to provide an easy generic RFC to any SAP system connected.

## Who Should Use It
Exsposing all RFC functions to everyone is not a good idea. You should always create for your customers a dedicated ICo for their case. That way it will be easy to follow and monitor such workflows in your organizations.
With that being said, for DevOps operations it might be painful creating and maintaing connections and implementation of each function. Writing an automation should be easy as calling an API on the web. For that, we can use connectors such as [PyRFC](https://github.com/SAP/PyRFC). But that makes us skip the SAP PI system, which supposed to be the enterprise service bus of our organization. Exsposing generic RFC API on SAP PI makes a microservice for calling RFC on all systems, which is reliable, always on tool for automation operations in the organization.

## How does it work
The main functionallity that being used is the fact that SAP systems distinguish RFC messages by the wrapper tag they contain. Declaring RFC message as message type only changes said wrapper. Combinig it with SAP PI converting messages to XML, and not validating output of any non-graphical mapping, dynamic mapping can be created to call any function name.

For example, let there be `ZSUM` function which receives `FIRSTNUM` and `SECONDNUM` numbers as the input, and returns `SUMNUM` as the output. if we wish to call it, all we have to do is send the system the following:
```XML
<ns0:ZSUM namespace="urn:sap-com:document:sap:rfc:functions">
  <FIRSTNUM>1</FIRSTNUM>
  <SECONDNUM>2</SECONDNUM>
</ns0:ZSUM>
```

and we will receive back:
```XML
<response:ZSUM namespace="urn:sap-com:document:sap:rfc:functions">
  <SUMNUM>3</SUMNUM>
</response:ZSUM>
```

## With REST Adapter
Although the mapping should work for any kind of interface and adapter, it was originally meant to provide easy way to access functions through REST API. This document will present a suggestion of usage, so don't feel limited to this implementation.

Users and code can send POST request to the following URL with the payload being the input of the function:

`https://<PI-ADDRESS>/RESTAdapter/<SID>/<RFC>`

`PI-ADDRESS` is of course, your PI's DNS/IP. `SID` is the way we determinate which SAP system to call. In the receiver determination part we can easily add conditions based on the value inserted. `RFC` is the name of the RFC function, which will be read in the mapping through `DynamicConfiguration` module.
It is important to seperate between the two resources in the URL by classifing each as diffrenet resource in the communication channel:

name | resource
---- | --------
SID | resource
RFC | resource2

That way, we can read the values as mentioned before using the matching resource type.

## Technical Implemantaion
The mapping is implemented in XSLT.
1. Firstly, the function name is selected from `DynamicConfiguration` API. Using the input param and the required Java classes, the function name is inserted into a xsl variable. In the current implementation, the function is selected from `resource2` value of the REST adapter, but any key can be used.
2. A wrapper element with the function variable as the name is dynamically created, along with the RFC namespace.
3. All of the payload provided is copied into the wrapper.

## How to Use
1. Download the mapping file. You may change the dynamic key for your needs.
2. Create Imported Archive in the ESR and import said file.
3. Create Operation Mapping using the archive created. You can select any message type as source and target. Don't forget to tick `Use SAP XML toolkit`.
4. In the IB, create Communication Channel of desired adapter as a sender, and RFC receiver for each system you will call. In the sender Communication Channel, you should maintain parameters for selecting the function and optionally the system. For example, `resource` & `resource2` in REST adapter.
5. Create ICo with all created objects.
6. Test on any function!

