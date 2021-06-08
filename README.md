# BazaartMobileBar
Build mobile bar with action buttons that can log into 8 edges on a canvas view

## Main Classes

### PortView
Just a UIView Inherited class with a isHorizontal boolean. Port Job is to
represent a rectangular corner on canvas (one of 8) that the mobile bar view 
can attach to

### PortView
Class to handle the ports:

   - Creation of all ports on canvas (and apply which one are horizontal (2 of them))
   - Intersection checks service: see if a view intersects one of the port view frames
   - Find out the nearest port to a view
   
### MobileBarView
Class to fascilitate the Mobile Bar View. Consists of background and a UIStackView
that accomodates 3 UIButtons. Also knows when and how to rotate the view (stack + buttons)
when an intersection is encountered with a port view. When buttons are pressed, MobileBarView
shall post a notification for containing VC to notify user has requested add/delete/save layer.
