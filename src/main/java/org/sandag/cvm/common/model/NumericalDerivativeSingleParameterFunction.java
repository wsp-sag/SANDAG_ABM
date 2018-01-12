/*
 Travel Model Microsimulation library
 Copyright (C) 2005 PbConsult, JE Abraham and others


  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/



package org.sandag.cvm.common.model;

public abstract class NumericalDerivativeSingleParameterFunction implements SingleParameterFunction {
    double delta;
    public NumericalDerivativeSingleParameterFunction(double delta) {
        this.delta=delta;
    }

    public double derivative(double point){
          double perturbed = evaluate(point+delta);
          return (perturbed-evaluate(point))/delta;
    }
}
