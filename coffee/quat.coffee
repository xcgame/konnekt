###
 0000000   000   000   0000000   000000000  
000   000  000   000  000   000     000     
000 00 00  000   000  000000000     000     
000 0000   000   000  000   000     000     
 00000 00   0000000   000   000     000     
###

class Quat

    constructor: (x, y, z, w) ->
        @x = x or 0
        @y = y or 0
        @z = z or 0
        @w = w ? 1

    copy: (q) ->
        @x = q.x
        @y = q.y
        @z = q.z
        @w = q.w
        @
        
    @axis: (v,a) -> @xyza v.x, v.y, v.z, a
        
    @xyza: (x,y,z,a=0) ->
        h = a / 2
        s = sin h
        quat x*s, y*s, z*s, cos h
        
    rotate: (v) ->

        x = v.x
        y = v.y
        z = v.z
        
        ix = @w * x + @y * z - @z * y
        iy = @w * y + @z * x - @x * z
        iz = @w * z + @x * y - @y * x
        iw = - @x * x - @y * y - @z * z

        x = ix * @w + iw * - @x + iy * - @z - iz * - @y
        y = iy * @w + iw * - @y + iz * - @x - ix * - @z
        z = iz * @w + iw * - @z + ix * - @y - iy * - @x
        
        vec x,y,z

    # angle: (q) -> 2 * acos abs clamp -1, 1, @dot q
    # dot: (v) -> @x * v.x + @y * v.y + @z * v.z + @w * v.w
    
    length: -> sqrt @x * @x + @y * @y + @z * @z + @w * @w
    zero: -> zero(@x) and zero(@y) and zero(@z)

    norm: ->
        l = @length()
        if l == 0
            @x = 0
            @y = 0
            @z = 0
            @w = 1
        else
            l = 1 / l
            @x = @x * l
            @y = @y * l
            @z = @z * l
            @w = @w * l
        @

    mul: (q) ->
        ax = @x
        ay = @y
        az = @z
        aw = @w
        @x = ax * q.w +  aw * q.x  +  ay * q.z  - (az * q.y)
        @y = ay * q.w +  aw * q.y  +  az * q.x  - (ax * q.z)
        @z = az * q.w +  aw * q.z  +  ax * q.y  - (ay * q.x)
        @w = aw * q.w - (ax * q.x) - (ay * q.y) - (az * q.z)
        @

    slerp: (b, t) ->
        
        if t == 0
            return @
        if t == 1
            return @copy b
            
        x = @x
        y = @y
        z = @z
        w = @w
        
        cht = w * b.w + x * b.x + y * b.y + z * b.z
        
        if cht < 0
            @w = -b.w
            @x = -b.x
            @y = -b.y
            @z = -b.z
            cht = -cht
        else
            @copy b
            
        if cht >= 1.0
            @w = w
            @x = x
            @y = y
            @z = z
            return @
            
        ssht = 1.0 - (cht * cht)
        if ssht <= Number.EPSILON
            s = 1 - t
            @w = s * w + t * @w
            @x = s * x + t * @x
            @y = s * y + t * @y
            @z = s * z + t * @z
            return @norm()
            
        sht = sqrt ssht
        ht = atan2 sht, cht
        ra = sin((1 - t) * ht) / sht
        rb = sin(t * ht) / sht
        @w = w * ra + @w * rb
        @x = x * ra + @x * rb
        @y = y * ra + @y * rb
        @z = z * ra + @z * rb
        @

quat = (x,y,z,w) -> new Quat x,y,z,w