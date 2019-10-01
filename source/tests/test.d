module tests.test;

unittest {
    import dllvm, std.stdio;

    loadLLVM();

    Context ctx = new Context();
    Module mod = new Module("MyModule", ctx);
    Builder builder = new Builder(ctx);

    Function myFunction;

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
    GenericValue value = exEngine.RunFunction(myFunction, [GenericValue.NewValue!int(ctx.CreateInt32(), 10), GenericValue.NewValue!int(ctx.CreateInt32(), 20)]);
    
    writeln("D call @myFunction i32 10 i32 20 = ", value.GetValue!int());

}