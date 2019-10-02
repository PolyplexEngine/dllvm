module tests.test;

unittest {
    import dllvm, std.stdio;

    loadLLVM();
    initExecutionEngine();

    Context ctx = new Context();
    Module mod = new Module("MyModule", ctx);
    Builder builder = new Builder(ctx);

    Function myFunction;
    Function myFunction2;

    /**
        Adder function
    */
    {
        FuncType fType = ctx.CreateFunction(ctx.CreateInt32(), [ctx.CreateInt32(), ctx.CreateInt32()], false);
        myFunction = new Function(mod, fType, "myFunction");
        BasicBlock entry = myFunction.AppendBasicBlock(ctx, "entry");
        builder.PositionAtStart(entry);
        Value valA = myFunction.GetParam(0);
        valA.Name = "paramA";
        Value valB = myFunction.GetParam(1);
        valB.Name = "paramB";
        Value result = builder.BuildAdd(valA, valB, "result");
        builder.BuildRet(result);
    }

    writeln(mod.toString());

    ExecutionEngine exEngine = new ExecutionEngine(mod);
    
    alias myFuncType = int function(int, int);
    myFuncType myFunc = exEngine.GetFunctionAddr!myFuncType("myFunction");

    //GenericValue value = exEngine.RunFunction(myFunction, [GenericValue.NewValue!int(ctx.CreateInt32(), 10), GenericValue.NewValue!int(ctx.CreateInt32(), 20)]);
    
    foreach(x; 1..10) {
        foreach_reverse(y; 1..10) {
            writeln(myFunc(x, y));
        }
    }

    /**
        Multiply function
    */
    {
        FuncType fType = ctx.CreateFunction(ctx.CreateInt32(), [ctx.CreateInt32(), ctx.CreateInt32()], false);
        myFunction2 = new Function(mod, fType, "myClass::myFunction(void)");
        BasicBlock entry = myFunction2.AppendBasicBlock(ctx, "entry");
        builder.PositionAtStart(entry);
        Value valA = myFunction2.GetParam(0);
        valA.Name = "paramA";
        Value valB = myFunction2.GetParam(1);
        valB.Name = "paramB";
        Value result = builder.BuildMul(valA, valB, "result");
        builder.BuildRet(result);

        writeln(myFunction2.Name);
    }

    exEngine.RecompileAll();

    writeln("TEST 2");

    myFuncType myFunc2 = exEngine.GetFunctionAddr!myFuncType("myClass::myFunction(void)");

    //GenericValue value = exEngine.RunFunction(myFunction, [GenericValue.NewValue!int(ctx.CreateInt32(), 10), GenericValue.NewValue!int(ctx.CreateInt32(), 20)]);
    
    foreach(x; 1..10) {
        foreach_reverse(y; 1..10) {
            writeln(myFunc2(x, y));
        }
    }

    writeln(mod.toString());

}