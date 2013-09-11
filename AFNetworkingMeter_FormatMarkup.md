# AFNetworkingMeter - evolution of the report format.

This is how it began.

```
AFNetworkingMeter - formatted reported
======================================
Requests: 7
Responses: 7
Sent (bytes): 44
Received (bytes): 74635
Minimal elapsed time for request (seconds): 0.0263
Maximal elapsed time for request (seconds): 0.823921
Image requests: (null)
Image responses: (null)
Image data received (bytes): (null)
Total server errors: (null)
Server errors: (null)
Total connection errors: (null)
Connection errors: (null)
```

Next step.

```
====================================
AFNetworkingMeter - formatted report
------------------------------------

Requests:                          7
Responses:                         7

Sent (bytes):                     44
Received (bytes):              74635

Elapsed time for request ...........

Min (seconds):                0.0263
Max (seconds):              0.823921

Images .............................

Requests:                    3324234
Responses:                    (null)
Data received (bytes):        (null)

Server errors ......................

Total:                             1
     1 x 404 Not Found

Connection errors ..................

Total:                           165
    12 x -1009 NSURLErrorNotConnectedToInternet
   155 x -1009 NSURLErrorRedirectToNonExistentLocation

====================================
```

Almost there:

```
====================================
AFNetworkingMeter - formatted report
------------------------------------

Requests:                          7
Responses:                         7

Sent (bytes):                     44
Received (bytes):              74635

Elapsed time for request ...........

Min (seconds):                0.0263
Max (seconds):              0.823921

Images .............................

Requests:                    3324234
Responses:                    (null)
Data received (bytes):        (null)

Server errors ......................

Total:                             1
404 Not Found                      1

Connection errors (NSURLError) .....

Total:                           165

-1009 NotConnectedToInternet      15
-1009 RedirectToNonExiste...    1000

====================================
```

Current one:

```
============================================
   AFNetworkingMeter  -  formatted report
--------------------------------------------

Requests:                                  7
Responses:                                 7

Sent (bytes):                             44
Received (bytes):                      74635

Elapsed time for request ...................

Min (seconds):                        0.0263
Max (seconds):                      0.823921

Images .....................................

Requests:                            3324234
Responses:                                 2
Data received (bytes):                     0

Server errors ..............................

Total:                                     1
404 Not Found                              1

Connection errors (NSURLError) .............

Total:                                   165
-1009 NotConnectedToInternet              15
-1009 RedirectToNonExistentLocation     5000

============================================
```
