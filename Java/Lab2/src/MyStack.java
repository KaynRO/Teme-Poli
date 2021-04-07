import java.util.ArrayList;

public class MyStack {
    public ArrayList<Object> list ;

    public MyStack(){
        this.list = new ArrayList<Object>() ;
    }

    public boolean isEmpty(){
        return this.list.isEmpty() ;
    }

    public int getSize(){
        return this.list.size() ;
    }

    public Object peek(){
        return this.list.get(this.list.size() - 1) ;
    }

    public Object pop(){
        Object o = this.peek() ;
        this.list.remove(o) ;
        return o ;
    }

    public void push(Object o){
        this.list.add(o) ;
    }

    public int search(Object o){
        if ( this.list.contains(o))
            return this.list.lastIndexOf(o) ;
        else return -1 ;
    }

    @Override
    public String toString(){
        StringBuilder text = new StringBuilder();
        for ( Object o : this.list )
            text.append(o.toString()) ;
        return text.toString() ;
    }

    public static void main(String[] args){
        MyStack stack = new MyStack() ;

        int v1 = 10 ;
        int v2 = 20 ;

        System.out.println(stack.isEmpty()) ;
        stack.push(v1) ;
        stack.push(v2) ;
        System.out.println(stack.getSize()) ;
        System.out.println(stack.peek().toString()) ;
        stack.pop() ;
        System.out.println(stack.search(v1)) ;
        System.out.println(stack.toString()) ;

    }
}